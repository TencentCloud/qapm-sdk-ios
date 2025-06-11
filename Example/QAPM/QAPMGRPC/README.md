# QAPM gRPC 监控接入指南

## 前置条件

- iOS 项目已集成 QAPM 5.4.9+

## 基础集成（快速接入）

- 将 QAPMMonitorClientInterceptor.swift 添加到 Xcode 工程
- 创建拦截器工厂

```
    import Foundation
    import GRPC
    import Logging
    // 假设GreeterClientInterceptorFactoryProtocol、HelloRequest、HelloResponse 是通过业务工程的hello.proto生成的协议

    final class QAPMInterceptorFactory: GreeterClientInterceptorFactoryProtocol, @unchecked Sendable {
        func makeSayHelloInterceptors() -> [ClientInterceptor<HelloRequest, HelloResponse>] {
            let interceptor = QAPMMonitorClientInterceptor<HelloRequest, HelloResponse>()
            return [interceptor]
        }
    }

```

- 新建GrpcModels+QAPM.swift文件，实现协议拓展

```
    //假设上述已经实现了HelloRequest、HelloResponse
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

```

- 创建grpc客户端

```
final class SyncGreeterClient {
private let group: EventLoopGroup
private let client: GreeterNIOClient

init(host: String, port: Int) throws {
    self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let interceptorFactory = QAPMInterceptorFactory()

    let channel = try GRPCChannelPool.with(
        target: .host(host, port: port),
        transportSecurity: .plaintext,
        eventLoopGroup: group
    )

    self.client = GreeterNIOClient(
        channel: channel,
        interceptors: interceptorFactory
    )

  }
}
```

## 高阶配置（定制化监控）

- 如果当前拦截器采集的数据不能满足您的业务需求，您可以使用自定义回调接口上报更多的数据

```
final class QAPMInterceptorFactory: GreeterClientInterceptorFactoryProtocol, @unchecked Sendable {

    // onStart、sendMessage、onMessage、onClose 通过回调接口注入业务特定数据，可选配置
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

```

- UV & UD 字段详解
| 字段类型 | 命名规则       | 数据类型   | 数量限制 | 典型应用场景    |
| ---- | ---------- | ------ | ---- | --------- |
| UV   | uv1 ~ uv10 | Int  | 10 个 | 分段耗时等，主要用于指标的聚合  |
| UD   | ud1 ~ ud5 | String | 5 个 | 地区、服务端ip等，主要用于日志上下文的展示 |



- 使用示例

```
 let factory = QAPMInterceptorFactory(
    onStart: { meta in
        meta.ud1 = UUID().uuidString                        // 唯一请求ID
    },
    sendMessage: { meta in
        meta.uv1 = Int(Date().timeIntervalSince1970 * 1000) // 发送请求消息时间戳
    },
    onClose: { meta in
        meta.ud2 = server.ip                                // 服务端ip
        meta.ud3 = region                                   // 地区
        meta.uv2 = Int(Date().timeIntervalSince1970 * 1000) // 结束通信时间戳
    }
)

```

