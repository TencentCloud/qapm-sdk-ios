import Foundation
import GRPC
import NIO
import Logging

// MARK: - 修改后的同步客户端
final class SyncGreeterClient {
    private let group: EventLoopGroup
    private let client: GreeterNIOClient
    
    init(host: String, port: Int) throws {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        
        // 创建拦截器工厂
        let interceptorFactory = QAPMInterceptorFactory(onStart: { meta in
            meta.uv1 = 1
            meta.uv2 = 2
            meta.uv3 = 3
            meta.uv4 = 4
            meta.uv5 = 5
            meta.uv6 = 6
            meta.uv7 = 7
            meta.uv8 = 8
            meta.uv9 = 9
            print("→ url: \(meta.url ?? "unknown")")
        },onMessage: { meta in
            meta.ud1 = "ud1"
            meta.ud2 = "ud2"
            meta.ud3 = "ud3"
            meta.ud4 = "ud4"
            meta.ud5 = "ud5"
            print("→ requestHeaders", meta.requestHeaders ?? [:])
        },onClose:  { meta in
            meta.ud1 = "ud1"
            meta.ud2 = "ud2"
            meta.ud3 = "ud3"
            meta.ud4 = "ud4"
            meta.ud5 = "ud5"
            print("→ responseHeaders", meta.responseHeaders ?? [:])
            print("→ statusCode: \(meta.statusCode)")
            print("→ responseBodySize: \(meta.responseBodySize)")
        })
        
        let channel = try GRPCChannelPool.with(
            target: .host(host, port: port),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )
        
        // 使用带拦截器的客户端初始化
        self.client = GreeterNIOClient(
            channel: channel,
            interceptors: interceptorFactory
        )
        
    }
    
    func sayHello(name: String) throws -> String {
        let request = HelloRequest.with { $0.name = name }
        let response = try client.sayHello(request).response.wait()
        return response.message
    }
    
    func shutdown() throws {
        try client.channel.close().wait()
        try group.syncShutdownGracefully()
    }
}



// MARK: - 修改后的异步客户端
@available(macOS 10.15, *)
final class AsyncGreeterClient {
    private let group: EventLoopGroup
    private let client: GreeterAsyncClient
    
    init(host: String, port: Int) throws {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        
        // 创建拦截器工厂
        let interceptorFactory = QAPMInterceptorFactory()
        
        let channel = try GRPCChannelPool.with(
            target: .host(host, port: port),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )
        
        // 使用带拦截器的客户端初始化
        self.client = GreeterAsyncClient(
            channel: channel,
            interceptors: interceptorFactory
        )
    }
    
    func sayHello(name: String) async throws -> String {
        let request = HelloRequest.with { $0.name = name }
        let response = try await client.sayHello(request)
        return response.message
    }
    
    func shutdown() throws {
        try client.channel.close().wait()
        try group.syncShutdownGracefully()
    }
}

final class RemoteServiceClient {
    private let client: HelloServiceClientProtocol
    private let group: EventLoopGroup
    
    init(host: String = "localhost", port: Int = 50051) {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let channel = try! GRPCChannelPool.with(
            target: .host(host, port: port),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )
        // 使用拦截器工厂初始化客户端
        self.client = HelloServiceNIOClient(
            channel: channel,
            interceptors: RemoteServiceClientQAPMInterceptorFactory(onStart: { meta in
                meta.uv1 = 1
                meta.uv2 = 2
                meta.uv3 = 3
                meta.uv4 = 4
                meta.uv5 = 5
                meta.uv6 = 6
                meta.uv7 = 7
                meta.uv8 = 8
                meta.uv9 = 9
                print("→ url: \(meta.url ?? "unknown")")
            },onMessage: { meta in
                meta.ud1 = "ud1"
                meta.ud2 = "ud2"
                meta.ud3 = "ud3"
                meta.ud4 = "ud4"
                meta.ud5 = "ud5"
                print("→ requestHeaders", meta.requestHeaders ?? [:])
            },onClose:  { meta in
                meta.ud1 = "ud1"
                meta.ud2 = "ud2"
                meta.ud3 = "ud3"
                meta.ud4 = "ud4"
                meta.ud5 = "ud5"
                print("→ responseHeaders", meta.responseHeaders ?? [:])
                print("→ statusCode: \(meta.statusCode)")
                print("→ responseBodySize: \(meta.responseBodySize)")
            })
        )
    }
        
    deinit {
        try? group.syncShutdownGracefully()
    }
        
    // 1. Unary Call
    func sayHello(name: String) {
        print("Sending unary request...")
        let request = HelloRequest.with { $0.name = name }
        
        let call = client.sayHello(request)
        do {
            let response = try call.response.wait()
            print("Unary response received: \(response.message), Data: \(response.data)")
        } catch {
            print("RPC failed: \(error)")
        }
    }
    
    // 2. Server Streaming
    func sayHelloServerStream(name: String) {
        print("Starting server streaming...")
        let request = HelloRequest.with { $0.name = name }
        
        let call = client.sayHelloServerStream(request) { response in
            print("Server stream received: \(response.message)")
        }
        
        do {
            _ = try call.status.wait()
            print("Server streaming completed")
        } catch {
            print("Server streaming failed: \(error)")
        }
    }
    
    // 3. Client Streaming
    func sayHelloClientStream(names: [String]) {
        print("Starting client streaming...")
        let call = client.sayHelloClientStream()
        call.response.whenSuccess { response in
            print("Client streaming final response: \(response.message)")
        }
        
        do {
            try names.forEach { name in
                let request = HelloRequest.with { $0.name = name }
                try call.sendMessage(request).wait()
                print("Sent client stream item: \(name)")
            }
            try call.sendEnd().wait()
        } catch {
            print("Client streaming failed: \(error)")
        }
    }
    
    // 4. Bidirectional Streaming
    func sayHelloBidiStream(names: [String]) {
        print("Starting bidirectional streaming...")
        let call = client.sayHelloBidiStream { response in
            print("Bidi stream received: \(response.message)")
        }
        
        do {
            try names.forEach { name in
                let request = HelloRequest.with { $0.name = name }
                try call.sendMessage(request).wait()
                print("Sent bidi stream item: \(name)")
                Thread.sleep(forTimeInterval: 1) // 模拟间隔
            }
            try call.sendEnd().wait()
            _ = try call.status.wait()
            print("Bidirectional streaming completed")
        } catch {
            print("Bidirectional streaming failed: \(error)")
        }
    }
    
    func shutdown() throws {
        try client.channel.close().wait()
        try group.syncShutdownGracefully()
    }
}

extension HelloRequest: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        return try? self.serializedData()
    }
}

extension HelloResponse: QAPMGRPCDataProtocol {
    public var gRPCRequestData: Data? {
        return try? self.serializedData()
    }
}
