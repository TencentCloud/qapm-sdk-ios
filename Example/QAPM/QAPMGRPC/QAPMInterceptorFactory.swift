//
//  QAPMInterceptorFactory.swift
//  SwiftTest
//
//  Created by wxyawang on 2025/4/2.
//

import Foundation
import GRPC
import Logging

final class QAPMInterceptorFactory: GreeterClientInterceptorFactoryProtocol, @unchecked Sendable {
    
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
    
    func makeSayHelloInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
        let interceptor = QAPMMonitorClientInterceptor<HelloRequest, HelloResponse>()
        interceptor.onStart = onStart
        interceptor.sendMessage = sendMessage
        interceptor.onMessage = onMessage
        interceptor.onClose = onClose
        return [interceptor]
    }
}
