import GRPC
import NIOCore
import NIOPosix
import NIO
import Logging

// MARK: - 服务实现
final class MyGreeterProvider: GreeterProvider {
    let interceptors: GreeterServerInterceptorFactoryProtocol? = nil

    func sayHello(
        request: HelloRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<HelloResponse> {
        let response = HelloResponse.with {
            $0.message = "Hello, \(request.name)!"
        }
        return context.eventLoop.makeSucceededFuture(response)
    }
}

