//
//  GRPCViewController.swift
//  QAPM_Example
//
//  Created by wxyawang on 2025/4/8.
//  Copyright © 2025 wxyawang. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import GRPC
import NIO
import NIOCore
import NIOPosix
import NIOHTTP2
import Logging


@objc(GRPCViewController)
class GRPCViewController: UIViewController {

    private var buttons: [UIButton] = []
    private let statusLabel = UILabel()
    private var client: OrderServiceClient?
    private var currentTask: Task<Void, Never>?
    
    private let buttonConfigs: [(title: String, color: UIColor, action: Selector)] = [
        ("启动hello服务端", .systemBlue, #selector(helloServerTapped)),
        ("启动hello客户端", .systemOrange, #selector(helloClientTapped)),
        ("启动order服务端", .systemPurple, #selector(orderServerTapped)),
        ("启动order客户端", .systemRed, #selector(orderClientTapped)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStatusLabel()
        setupButtons()
        setupStackView()
    }
    
    private func updateStatus(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let currentText = self.statusLabel.text ?? ""
            let newText = currentText.isEmpty ? text : "\(currentText)\n\(text)"
            UIView.transition(with: self.statusLabel,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.statusLabel.text = newText
                              },
                              completion: nil)
            
        }
    }

    private func clearStatus() {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = nil
        }
    }
    
    private func setupButtons() {
        for config in buttonConfigs {
            let button = createButton(
                title: config.title,
                color: config.color,
                action: config.action
            )
            buttons.append(button)
        }
    }
    private func setupStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.textColor = .darkGray
        statusLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        statusLabel.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        view.addSubview(statusLabel)
    
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        buttons.forEach { stackView.addArrangedSubview($0) }
        
        buttons.forEach {
            $0.widthAnchor.constraint(equalToConstant: 200).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func helloServerTapped() {
        DispatchQueue.global(qos: .background).async { [self] in
           do {
               try helloServer()
           } catch {
               print("hello服务端启动失败: \(error)")
           }
       }
    }
        
    @objc private func helloClientTapped() {
        DispatchQueue.global(qos: .background).async { [self] in
           do {
               try helloClient()
           } catch {
               print("hello客户端启动失败: \(error)")
           }
       }
    }
    
    @objc private func orderServerTapped() {
        DispatchQueue.global(qos: .background).async {
            [self] in
            Task {
                do {
                    try await orderServer()
                } catch {
                    print("order服务端启动失败: \(error)")
                }
            }
        }
    }
 
    @objc private func orderClientTapped() {
        
        DispatchQueue.global(qos: .background).async { [self] in
           do {
               try orderClient()
           } catch {
               print("order客户端启动失败: \(error)")
           }
       }
    }
       
    func helloServer() throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        defer { try! eventLoopGroup.syncShutdownGracefully() }

        let server = try Server.insecure(group: eventLoopGroup)
            .withServiceProviders([MyGreeterProvider()])
            .bind(host: "localhost", port: 50051)
            .wait()
        print("✅ 服务端已启动 (\(server.channel.localAddress!))")
        try server.onClose.wait()
        
    }
    
    func helloClient() throws {
        do {
            let syncClient = try SyncGreeterClient(
                host: "localhost",
                port: 50051
            )
            
            let message = try syncClient.sayHello(name: "Alice")
            print("[同步] 响应: \(message)")
            try syncClient.shutdown()
        } catch {
            print("[同步] 错误: \(error)")
        }
    }
    
    func orderServer() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            Task.detached { [eventLoopGroup] in
                try? await eventLoopGroup.shutdownGracefully()
            }
        }
        
        let server = try await Server.insecure(group: eventLoopGroup)
            .withServiceProviders([OrderProvider()])
            .bind(host: "localhost", port: 50058)
            .get()
        
        print("✅ 服务端已启动，监听端口: \(server.channel.localAddress!.port!)")
        
        try await withCheckedThrowingContinuation { continuation in
            server.onClose.whenComplete { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func orderClient() throws {
        clearStatus()
        // 防止重复点击
        guard currentTask == nil else {
            self.showAlert(message: "已有操作进行中")
            return
        }
        self.currentTask = Task { [weak self] in
            defer {
                self?.currentTask = nil
            }
            
            do {
                self!.client = try OrderServiceClient(
                    host: "localhost",
                    port: 50058
                )
                
                guard let self = self else {
                    print("ViewController 已释放，终止操作")
                    return
                }
             
                let order = try await self.createDemoOrder(client: client!)
                
                await MainActor.run {
                    self.updateStatus("订单创建成功: \(order.orderID)")
                    self.updateStatus("订单ID: \(order.orderID)")
                }
                
                let paymentID = try await client!.processPayment(
                    orderID: order.orderID,
                    amount: order.totalAmount
                )
             
                await MainActor.run {
                    self.updateStatus("支付完成: \(paymentID)")
                }
                
                let updatedOrder = try await client!.getOrder(orderID: order.orderID)
                await MainActor.run {
                    self.updateStatus("当前状态: \(updatedOrder.status.rawValue)")
                }
                
            } catch let error as GRPCStatus {
                await self?.handleGRPCError(error)
            } catch {
                await self?.handleGenericError(error)
            }
        }
    }
        
    private func createDemoOrder(client: OrderServiceClient) async throws -> Ordersystem_Order {
        let items = [
            Ordersystem_OrderItem.with {
                $0.productID = "P-1001"
                $0.quantity = 2
                $0.price = 4999.0
            },
            Ordersystem_OrderItem.with {
                $0.productID = "P-1002"
                $0.quantity = 2
                $0.price = 19999.0
            },
            Ordersystem_OrderItem.with {
                $0.productID = "P-1003"
                $0.quantity = 2
                $0.price = 19999.0
            }
        ]
        return try await client.createOrder(userID: "user_\(UUID().uuidString)", items: items)
    }
        
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "错误",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @MainActor
    private func handleGRPCError(_ error: GRPCStatus) async {
        let message: String
        switch error.code {
        case .unavailable:
            message = "服务不可用，请检查网络"
        case .deadlineExceeded:
            message = "请求超时，请重试"
        default:
            message = "服务错误: \(error.message ?? "未知错误")"
        }
        self.statusLabel.text = message
        self.showAlert(message: message)
    }

    @MainActor
    private func handleGenericError(_ error: Error) async {
        let message: String
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                message = "网络连接已断开"
            case .timedOut:
                message = "连接超时"
            default:
                message = "网络错误: \(urlError.localizedDescription)"
            }
        } else {
            message = "操作失败: \(error.localizedDescription)"
        }
        self.statusLabel.text = message
        self.showAlert(message: message)
    }
    
}
