//
//  QAPMMonitorClientInterceptor.swift
//  QAPM
//
//  Created by wxyawang on 2025/4/2.
//

import Foundation
import GRPC
import NIO
import NIOHPACK
import QAPM

public final class QAPMMonitorClientInterceptor<Request: QAPMGRPCDataProtocol, Response: QAPMGRPCDataProtocol>: ClientInterceptor<Request, Response>, @unchecked Sendable {
    
    public var onStart: ((inout QAPMGrpcMeta) -> Void)?
    public var sendMessage: ((inout QAPMGrpcMeta) -> Void)?
    public var onMessage: ((inout QAPMGrpcMeta) -> Void)?
    public var onClose: ((inout QAPMGrpcMeta) -> Void)?
    
    private var totalRequestSize = 0
    private var totalResponseSize = 0
    private var currentCustomFields: NSMutableDictionary?
    private var currentMeta = QAPMGrpcMeta()
    private var transaction: QAPMNetworkTransaction?
    
    public override init() {
        super.init()
    }
    
    // MARK: - send Handling
    public override func send(
        _ part: GRPCClientRequestPart<Request>,
        promise: EventLoopPromise<Void>?,
        context: ClientInterceptorContext<Request, Response>
    ) {
        guard QAPMGrpcProfile.getInstance().enable() else {
            context.send(part, promise: promise)
            return
        }
        
        switch part {
        case let .metadata(headers):
            initializeTransaction(context: context, headers: headers)
            triggerOnStart()
        case let .message(request, _):
            handleRequestMessage(request)
            triggerSendMessage()
        case .end:
            break
        }
        context.send(part, promise: promise)
    }
    
    // MARK: - receive Handling
    public override func receive(
        _ part: GRPCClientResponsePart<Response>,
        context: ClientInterceptorContext<Request, Response>
    ) {
        guard QAPMGrpcProfile.getInstance().enable() else {
            context.receive(part)
            return
        }
        
        switch part {
        case let .metadata(headers):
            handleResponseHeaders(headers)
        case let .message(response):
            handleResponseMessage(response)
            triggerOnMessage()
        case let .end(status, _):
            triggerOnClose()
            finalizeTransaction(status: status)
        }
        context.receive(part)
    }
    
    // MARK: - errorCaught Handling
    public override func errorCaught(_ error: Error, context: ClientInterceptorContext<Request, Response>) {
        guard QAPMGrpcProfile.getInstance().enable() else {
            super.errorCaught(error, context: context)
            return
        }
        handleError(error)
        triggerOnClose()
        super.errorCaught(error, context: context)
    }
    
    // MARK: - Cancel Handling
    public override func cancel(
        promise: EventLoopPromise<Void>?,
        context: ClientInterceptorContext<Request, Response>
    ) {
        guard QAPMGrpcProfile.getInstance().enable() else {
            context.cancel(promise: promise)
            return
        }
        let error = NSError(
            domain: NSCocoaErrorDomain,
            code: NSUserCancelledError,
            userInfo: [NSLocalizedDescriptionKey: "Request cancelled by user"]
        )
        handleError(error)
        triggerOnClose()
        context.cancel(promise: promise)
    }
}

private extension QAPMMonitorClientInterceptor {
    private func initializeTransaction(
        context: ClientInterceptorContext<Request, Response>,
        headers: HPACKHeaders
    ) {
        // 1.获取基础信息
        guard transaction == nil else { return }
        currentCustomFields = NSMutableDictionary()
        let authority = (try? getAuthority(context: context)) ?? "unknown-host"
        let (service, method) = parseServiceMethod(from: context.path)
        let url = "grpc://\(authority)/\(service)/\(method)"
        guard let newTransaction = QAPMNetworkTransaction(url: url, library:"grpc") else {
            return
        }
        transaction = newTransaction
        transaction?.start()
        transaction?.setMethod(method)
        transaction?.setProtocol("grpc")
        transaction?.setIP(authority)
        
        let updatedHeaders = injectTraceHeaders(
            into: headers,
            url: url,
            authority: authority
        )
        
        let requestHeader = updatedHeaders.toAnyHashable()
        transaction?.setRequestHeader(requestHeader)
        
        currentMeta.updateURL(url)
        currentMeta.updateMethod(method)
        currentMeta.updateProtocol("grpc")
        currentMeta.updateHost(authority)
        currentMeta.updateRequestHeaders(updatedHeaders.toAnyHashable())
    }
        
    private func handleRequestMessage(_ request: Request) {
        guard let data = request.gRPCRequestData else { return }
        totalRequestSize += data.count
        transaction?.setRequestBodySize(totalRequestSize)
        currentMeta.updateRequestBodySize(totalRequestSize)
    }
    
    private func handleResponseHeaders(_ headers: HPACKHeaders) {
        let header = headers.toAnyHashable()
        transaction?.setResponseHeader(header)
        currentMeta.updateResponseHeaders(header)
    }
    
    private func handleResponseMessage(_ response: Response) {
        guard let data = response.gRPCRequestData else { return }
        totalResponseSize += data.count
        transaction?.setResponseBodySize(totalResponseSize)
        currentMeta.updateResponseBodySize(totalResponseSize)
    }
    
    private func finalizeTransaction(status: GRPCStatus) {
        let code = Int(status.code.rawValue)
        transaction?.setCode(code)
        currentMeta.updateStatusCode(code)
        
        if status.code == .ok {
            transaction?.finish()
        } else {
            let error = status.qapmError
            transaction?.finishWithError(error)
        }
        cleanup()
    }
    
    func handleError(_ error: Error) {
        let nsError: NSError = {
            if let grpcError = error as? GRPCStatus {
                return grpcError.qapmError
            }
            return error as NSError
        }()
        transaction?.setCode(nsError.code)
        currentMeta.updateStatusCode(nsError.code)
        transaction?.finishWithError(nsError)
        cleanup()
    }
}

private extension QAPMMonitorClientInterceptor {
    func triggerOnStart() {
        onStart?(&currentMeta)
        applyMeta(currentMeta)
    }
    
    func triggerSendMessage() {
        sendMessage?(&currentMeta)
        applyMeta(currentMeta)
    }
    
    func triggerOnMessage() {
        onMessage?(&currentMeta)
        applyMeta(currentMeta)
    }
    
    func triggerOnClose() {
        onClose?(&currentMeta)
        applyMeta(currentMeta)
    }
        
    private func applyMeta(_ meta: QAPMGrpcMeta) {
        
        var data = [AnyHashable: Any]()
        if let uv1 = meta.uv1 { data["uv1"] = uv1 }
        if let uv2 = meta.uv2 { data["uv2"] = uv2 }
        if let uv3 = meta.uv3 { data["uv3"] = uv3 }
        if let uv4 = meta.uv4 { data["uv4"] = uv4 }
        if let uv5 = meta.uv5 { data["uv5"] = uv5 }
        if let uv6 = meta.uv6 { data["uv6"] = uv6 }
        if let uv7 = meta.uv7 { data["uv7"] = uv7 }
        if let uv8 = meta.uv8 { data["uv8"] = uv8 }
        if let uv9 = meta.uv9 { data["uv9"] = uv9 }
        if let uv10 = meta.uv10 { data["uv10"] = uv10 }
        
        if let ud1 = meta.ud1 { data["ud1"] = ud1 }
        if let ud2 = meta.ud2 { data["ud2"] = ud2 }
        if let ud3 = meta.ud3 { data["ud3"] = ud3 }
        if let ud4 = meta.ud4 { data["ud4"] = ud4 }
        if let ud5 = meta.ud5 { data["ud5"] = ud5 }
        
        if !data.isEmpty {
            currentCustomFields?.addEntries(from: data)
            transaction?.setCustomField(currentCustomFields as? [AnyHashable : Any])
        }
    }
}

private extension QAPMMonitorClientInterceptor {
    func cleanup() {
        transaction = nil
        currentMeta = QAPMGrpcMeta()
        totalRequestSize = 0
        totalResponseSize = 0
    }
        
    private func injectTraceHeaders(
        into headers: HPACKHeaders,
        url: String,
        authority: String
    ) -> HPACKHeaders {
        var headers = headers
        guard let transaction = self.transaction else {
            return headers
        }
        
        let shouldInjectTraceparent = headers.first(name: "traceparent") == nil
        let shouldInjectSW8 = headers.first(name: "sw8") == nil
        
        if shouldInjectTraceparent,
           let traceparent = transaction.generateSw8TraceId(url, requestHost: authority),
           !traceparent.isEmpty {
            headers.replaceOrAdd(name: "traceparent", value: traceparent)
        }
        
        if shouldInjectSW8,
           let sw8 = transaction.generateTraceparentTraceId(),
           !sw8.isEmpty {
            headers.replaceOrAdd(name: "sw8", value: sw8)
        }
        
        return headers
    }
    
    func constructURL(
        context: ClientInterceptorContext<Request, Response>,
        authority: String
    ) -> String {
        let (service, method) = parseServiceMethod(from: context.path)
        return "\("grpc")://\(authority)/\(service)/\(method)"
    }
    func parseServiceMethod(from path: String) -> (String, String) {
        let components = path.split(separator: "/", omittingEmptySubsequences: true)
        guard components.count >= 2 else {
            return ("unknown-service", "unknown-method")
        }
        return (String(components[0]), String(components[1]))
    }
    
    func getAuthority(context: ClientInterceptorContext<Request, Response>) throws -> String {
        do {
            return try reflectAuthority(from: context)
        } catch {
            return "unknown-host"
        }
    }
    
    func reflectAuthority(from context: ClientInterceptorContext<Request, Response>) throws -> String {
        let mirror = Mirror(reflecting: context)
        
        guard let pipeline = mirror.descendant("_pipeline") else {
            throw ReflectionError.missingPipeline
        }
        
        let pipelineMirror = Mirror(reflecting: pipeline)
        guard let details = pipelineMirror.descendant("details") else {
            throw ReflectionError.missingDetails
        }
        
        let detailsMirror = Mirror(reflecting: details)
        guard let authority = detailsMirror.descendant("authority") as? String else {
            throw ReflectionError.missingAuthority
        }
        
        return authority
    }
    
    enum ReflectionError: Error {
        case missingPipeline
        case missingDetails
        case missingAuthority
    }
}

extension HPACKHeaders {
    fileprivate func toAnyHashable() -> [AnyHashable: Any] {
        return self.reduce(into: [:]) { dict, header in
            dict[header.name] = header.value
        }
    }
    
    fileprivate func filter(_ isIncluded: (String) -> Bool) -> HPACKHeaders {
        var filtered = HPACKHeaders()
        for header in self {
            if isIncluded(header.name) {
                filtered.add(name: header.name, value: header.value)
            }
        }
        return filtered
    }
}

extension GRPCStatus {
    fileprivate var qapmError: NSError {
        NSError(
            domain: "GRPCStatus",
            code: Int(self.code.rawValue),
            userInfo: [NSLocalizedDescriptionKey: self.message ?? "Unknown GRPC error"]
        )
    }
}

public protocol QAPMGRPCDataProtocol {
    var gRPCRequestData: Data? { get }
}

public struct QAPMGrpcMeta {
    // 用户自定义字段
    public var uv1: Int?
    public var uv2: Int?
    public var uv3: Int?
    public var uv4: Int?
    public var uv5: Int?
    public var uv6: Int?
    public var uv7: Int?
    public var uv8: Int?
    public var uv9: Int?
    public var uv10: Int?
    
    public var ud1: String?
    public var ud2: String?
    public var ud3: String?
    public var ud4: String?
    public var ud5: String?
    
    // 新增只读事务属性
    public private(set) var url: String?
    public private(set) var method: String?
    public private(set) var `protocol`: String?
    public private(set) var host: String?
    public private(set) var requestHeaders: [AnyHashable: Any]?
    public private(set) var responseHeaders: [AnyHashable: Any]?
    public private(set) var requestBodySize: Int = 0
    public private(set) var responseBodySize: Int = 0
    public private(set) var statusCode: Int = 0
     
    
    public init() {}
    
    fileprivate mutating func updateURL(_ value: String) { url = value }
    fileprivate mutating func updateMethod(_ value: String) { method = value }
    fileprivate mutating func updateProtocol(_ value: String) { `protocol` = value }
    fileprivate mutating func updateHost(_ value: String) { host = value }
    fileprivate mutating func updateRequestHeaders(_ value: [AnyHashable: Any]?) { requestHeaders = value }
    fileprivate mutating func updateResponseHeaders(_ value: [AnyHashable: Any]?) { responseHeaders = value }
    fileprivate mutating func updateRequestBodySize(_ value: Int) { requestBodySize = value }
    fileprivate mutating func updateResponseBodySize(_ value: Int) { responseBodySize = value }
    fileprivate mutating func updateStatusCode(_ value: Int) { statusCode = value }
}
