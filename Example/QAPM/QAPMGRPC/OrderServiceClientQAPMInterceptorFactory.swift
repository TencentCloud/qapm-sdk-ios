//
//  OrderServiceClientQAPMInterceptorFactory.swift
//  SwiftTest
//
//  Created by wxyawang on 2025/4/2.
//

import Foundation
import GRPC
import NIO

// MARK: - 核心拦截器工厂
final class OrderServiceClientQAPMInterceptorFactory: Ordersystem_OrderServiceClientInterceptorFactoryProtocol, @unchecked Sendable {
    private let lock = NSLock()
    
    private func makeInterceptor<Req: QAPMGRPCDataProtocol, Res: QAPMGRPCDataProtocol>() -> [ClientInterceptor<Req, Res>] {
        lock.withLock {
            [QAPMMonitorClientInterceptor<Req, Res>()]
        }
    }
    
    func makeCreateOrderInterceptors() -> [ClientInterceptor<Ordersystem_CreateOrderRequest, Ordersystem_OrderResponse>] {
        makeInterceptor()
    }
    
    func makeGetOrderInterceptors() -> [ClientInterceptor<Ordersystem_GetOrderRequest, Ordersystem_OrderResponse>] {
        makeInterceptor()
    }
    
    func makeCancelOrderInterceptors() -> [ClientInterceptor<Ordersystem_CancelOrderRequest, Ordersystem_OrderResponse>] {
        makeInterceptor()
    }
    
    func makeProcessPaymentInterceptors() -> [ClientInterceptor<Ordersystem_PaymentRequest, Ordersystem_PaymentResponse>] {
        makeInterceptor()
    }
    
    func makeUpdateStockInterceptors() -> [ClientInterceptor<Ordersystem_StockUpdateRequest, Ordersystem_StockUpdateResponse>] {
        makeInterceptor()
    }
}

extension Ordersystem_CreateOrderRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? serializedData()
    }
}

extension Ordersystem_OrderResponse: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? serializedData()
    }
}

extension Ordersystem_GetOrderRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

extension Ordersystem_CancelOrderRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

extension Ordersystem_PaymentRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

extension Ordersystem_PaymentResponse: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

extension Ordersystem_StockUpdateRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

extension Ordersystem_StockUpdateResponse: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        try? self.serializedData()
    }
}

