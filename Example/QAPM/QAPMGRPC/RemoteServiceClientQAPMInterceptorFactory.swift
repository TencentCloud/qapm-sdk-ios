//
//  RemoteServiceClientQAPMInterceptorFactory.swift
//  SwiftTest
//
//  Created by wxyawang on 2025/4/2.
//

import Foundation
import GRPC
import NIO

// MARK: - 核心拦截器工厂
final class RemoteServiceClientQAPMInterceptorFactory: HelloServiceClientInterceptorFactoryProtocol, @unchecked Sendable {
    private let lock = NSLock()
    
    private var onStart: ((inout QAPMGrpcMeta) -> Void)?
    private var sendMessage: ((inout QAPMGrpcMeta) -> Void)?
    private var onMessage: ((inout QAPMGrpcMeta) -> Void)?
    private var onClose: ((inout QAPMGrpcMeta) -> Void)?

    init(
        onStart: ((inout QAPMGrpcMeta) -> Void)? = nil,
        sendMessage: ((inout QAPMGrpcMeta) -> Void)? = nil,
        onMessage: ((inout QAPMGrpcMeta) -> Void)? = nil,
        onClose: ((inout QAPMGrpcMeta) -> Void)? = nil
    ) {
        self.onStart = onStart
        self.sendMessage = sendMessage
        self.onMessage = onMessage
        self.onClose = onClose
    }
    
    private func makeInterceptor<Req: QAPMGRPCDataProtocol, Res: QAPMGRPCDataProtocol>() -> [ClientInterceptor<Req, Res>] {
        lock.withLock {
            let interceptor = QAPMMonitorClientInterceptor<Req, Res>()
            interceptor.onStart = onStart
            interceptor.sendMessage = sendMessage
            interceptor.onMessage = onMessage
            interceptor.onClose = onClose
            return [interceptor]
        }
    }

    func makeSayHelloInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
        makeInterceptor()
    }

    func makeSayHelloServerStreamInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
        makeInterceptor()
    }

    func makeSayHelloClientStreamInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
        makeInterceptor()
    }

    func makeSayHelloBidiStreamInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
        makeInterceptor()
    }
}


