import Foundation
import GRPC
import NIO
import SwiftProtobuf

// MARK: - 自定义业务逻辑类（管理订单和产品）
final class OrderSystem {
    var orders: [String: Ordersystem_Order] = [:]
    var products: [String: Ordersystem_Product] = [
        "P-1001": .with {
            $0.id = "P-1001"
            $0.name = "iPhone 15"
            $0.price = 4999.0
            $0.stock = 100
        },
        "P-1002": .with {
            $0.id = "P-1002"
            $0.name = "MacBook Pro"
            $0.price = 19999.0
            $0.stock = 50
        },
        "P-1003": .with {
            $0.id = "P-1003"
            $0.name = "MacBook Pro"
            $0.price = 19999.0
            $0.stock = 50
        }
    ]
    let lock = NSLock()
}

// MARK: - gRPC 服务实现
final class OrderProvider: Ordersystem_OrderServiceProvider {
    let system = OrderSystem()
    var interceptors: Ordersystem_OrderServiceServerInterceptorFactoryProtocol?
    
    // MARK: - 创建订单（修复 productID 访问问题）
    func createOrder(
        request: Ordersystem_CreateOrderRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Ordersystem_OrderResponse> {
        system.lock.lock()
        defer { system.lock.unlock() }
        
        // 1. 验证所有商品库存
        for item in request.items {
            guard let product = system.products[item.productID] else {
                return context.eventLoop.makeFailedFuture(
                    GRPCStatus(code: .notFound, message: "Product \(item.productID) not found")
                )
            }
            guard product.stock >= item.quantity else {
                return context.eventLoop.makeFailedFuture(
                    GRPCStatus(code: .resourceExhausted, message: "Insufficient stock for \(product.name)")
                )
            }
        }
        
        // 2. 扣减库存
        for item in request.items {
            guard var product = system.products[item.productID] else { continue }
            product.stock -= item.quantity
            system.products[item.productID] = product
        }
        
        // 3. 创建订单
        let orderID = UUID().uuidString
        let totalAmount = request.items.reduce(0.0) { sum, item in
            guard let product = system.products[item.productID] else { return sum }
            return sum + (product.price * Double(item.quantity))
        }
        
        let newOrder = Ordersystem_Order.with {
            $0.orderID = orderID
            $0.userID = request.userID
            $0.items = request.items
            $0.status = .paymentPending
            $0.totalAmount = totalAmount
            $0.createdAt = Int64(Date().timeIntervalSince1970)
        }
        
        system.orders[orderID] = newOrder
        
        return context.eventLoop.makeSucceededFuture(
            Ordersystem_OrderResponse.with {
                $0.success = true
                $0.order = newOrder
                $0.errorMessage = ""
            }
        )
    }
    
    // MARK: - 获取订单
    func getOrder(
        request: Ordersystem_GetOrderRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Ordersystem_OrderResponse> {
        system.lock.lock()
        defer { system.lock.unlock() }
        
        guard let order = system.orders[request.orderID] else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .notFound, message: "Order \(request.orderID) not found")
            )
        }
        
        return context.eventLoop.makeSucceededFuture(
            Ordersystem_OrderResponse.with {
                $0.success = true
                $0.order = order
                $0.errorMessage = ""
            }
        )
    }
    
    // MARK: - 取消订单（修复库存恢复逻辑）
    func cancelOrder(
        request: Ordersystem_CancelOrderRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Ordersystem_OrderResponse> {
        system.lock.lock()
        defer { system.lock.unlock() }
        
        guard var order = system.orders[request.orderID] else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .notFound, message: "Order \(request.orderID) not found")
            )
        }
        
        // 恢复所有商品库存
        for item in order.items {
            guard var product = system.products[item.productID] else { continue }
            product.stock += item.quantity
            system.products[item.productID] = product
        }
        
        order.status = .cancelled
        system.orders[request.orderID] = order
        
        return context.eventLoop.makeSucceededFuture(
            Ordersystem_OrderResponse.with {
                $0.success = true
                $0.order = order
                $0.errorMessage = ""
            }
        )
    }
    
    // MARK: - 处理支付
    func processPayment(
        request: Ordersystem_PaymentRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Ordersystem_PaymentResponse> {
        system.lock.lock()
        defer { system.lock.unlock() }
        
        guard var order = system.orders[request.orderID] else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .notFound, message: "Order \(request.orderID) not found")
            )
        }
        
        // 验证支付金额
        guard request.amount == order.totalAmount else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .invalidArgument, message: "Payment amount mismatch")
            )
        }
        
        // 模拟支付处理
        let paymentSuccess = Int.random(in: 1...100) > 50 // 50% 成功率
        
        if paymentSuccess {
            order.status = .paid
            order.paymentID = UUID().uuidString
            system.orders[request.orderID] = order
            
            return context.eventLoop.makeSucceededFuture(
                Ordersystem_PaymentResponse.with {
                    $0.success = true
                    $0.paymentID = order.paymentID
                    $0.errorCode = ""
                }
            )
        } else {
            return context.eventLoop.makeSucceededFuture(
                Ordersystem_PaymentResponse.with {
                    $0.success = false
                    $0.paymentID = ""
                    $0.errorCode = "PAYMENT_DECLINED"
                }
            )
        }
    }
    
    func updateStock(
        request: Ordersystem_StockUpdateRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Ordersystem_StockUpdateResponse> {
        system.lock.lock()
        defer { system.lock.unlock() }
        
        guard var product = system.products[request.productID] else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .notFound, message: "Product \(request.productID) not found")
            )
        }
        
        let newStock = product.stock + request.delta
        guard newStock >= 0 else {
            return context.eventLoop.makeFailedFuture(
                GRPCStatus(code: .invalidArgument, message: "Stock cannot be negative")
            )
        }
        
        product.stock = newStock
        system.products[request.productID] = product
        
        return context.eventLoop.makeSucceededFuture(
            Ordersystem_StockUpdateResponse.with {
                $0.success = true
                $0.newStock = newStock
            }
        )
    }
}

