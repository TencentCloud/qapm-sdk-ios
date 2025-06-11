import Foundation
import GRPC
import NIO
import SwiftProtobuf

// MARK: - 客户端错误类型
enum OrderClientError: Error {
    case connectionFailed(GRPCStatus)
    case invalidResponse
    case paymentFailed(code: String)
    case custom(message: String)
}

// MARK: - 订单客户端封装
final class OrderServiceClient {
    private let eventLoopGroup: EventLoopGroup
    private var client: Ordersystem_OrderServiceClientProtocol?
    private let interceptors: Ordersystem_OrderServiceClientInterceptorFactoryProtocol
    private let lock = NSLock()
    
    // MARK: - 初始化
    init(
        host: String,
        port: Int
    ) throws {
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads:1)
        interceptors = OrderServiceClientQAPMInterceptorFactory()
        connect(host: host, port: port)
    }
    
    deinit {
        try? client?.channel.close().wait()
        try? eventLoopGroup.syncShutdownGracefully()
    }
        
    // MARK: - 连接管理
    private func connect(host: String, port: Int) {
        lock.withLock {
            do {
                let channel = try GRPCChannelPool.with(
                    target: .host(host, port: port),
                    transportSecurity: .plaintext,
                    eventLoopGroup: eventLoopGroup
                )
                
                client = Ordersystem_OrderServiceNIOClient(
                    channel: channel,
                    interceptors: interceptors
                )
            } catch {
                fatalError("Failed to create gRPC channel: \(error)")
            }
        }
    }
    
    func createOrder(
        userID: String,
        items: [Ordersystem_OrderItem]
    ) async throws -> Ordersystem_Order {
        guard let client = client else {
            throw OrderClientError.connectionFailed(.init(code: .unavailable, message: "Client not initialized"))
        }
        
        let request = Ordersystem_CreateOrderRequest.with {
            $0.userID = userID
            $0.items = items
        }
        
        do {
            let call = client.createOrder(request)
            let response = try await call.response.get()
            
            guard response.hasOrder else {
                throw OrderClientError.invalidResponse
            }
            return response.order
        } catch let error as GRPCStatus {
            throw OrderClientError.connectionFailed(error)
        } catch {
            throw OrderClientError.custom(message: error.localizedDescription)
        }
    }
    
    func getOrder(orderID: String) async throws -> Ordersystem_Order {
        guard let client = client else {
            throw OrderClientError.connectionFailed(.init(code: .unavailable, message: "Client not initialized"))
        }
        
        let request = Ordersystem_GetOrderRequest.with { $0.orderID = orderID }
        
        do {
            let call = client.getOrder(request)
            let response = try await call.response.get()
            
            guard response.hasOrder else {
                throw OrderClientError.invalidResponse
            }
            return response.order
        } catch let error as GRPCStatus {
            throw OrderClientError.connectionFailed(error)
        }
    }

    func cancelOrder(orderID: String) async throws -> Ordersystem_Order {
        guard let client = client else {
            throw OrderClientError.connectionFailed(.init(code: .unavailable, message: "Client not initialized"))
        }
        
        let request = Ordersystem_CancelOrderRequest.with { $0.orderID = orderID }
        
        do {
            let call = client.cancelOrder(request)
            let response = try await call.response.get()
            
            guard response.hasOrder else {
                throw OrderClientError.invalidResponse
            }
            return response.order
        } catch let error as GRPCStatus {
            throw OrderClientError.connectionFailed(error)
        }
    }
     
    
    func processPayment(orderID: String,amount: Double) async throws -> String {
        guard let client = client else {
            throw OrderClientError.connectionFailed(.init(code: .unavailable, message: "Client not initialized"))
        }
        
        let request = Ordersystem_PaymentRequest.with {
            $0.orderID = orderID
            $0.amount = amount
        }
        
        do {
            let call = client.processPayment(request)
            let response = try await call.response.get()
            
            guard response.success else {
                throw OrderClientError.paymentFailed(code: response.errorCode)
            }
            
            guard !response.paymentID.isEmpty else {
                throw OrderClientError.invalidResponse
            }
            
            return response.paymentID
        } catch let error as GRPCStatus {
            throw OrderClientError.connectionFailed(error)
        } catch {
            throw OrderClientError.custom(message: error.localizedDescription)
        }
    }
}


 
