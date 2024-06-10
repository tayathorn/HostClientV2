//
//  WebSocketClient.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation
import Starscream

protocol WebSocketClientDelegate: AnyObject {
    func didReceiveMessage(_ message: String)
    func didReceiveData(_ data: Data)
}

class WebSocketClient: WebSocketDelegate {
    var socket: WebSocket
    
    weak var delegate: WebSocketClientDelegate?
    
    init() {
        var request = URLRequest(url: URL(string: "http://\(ServerConfiguration.ip):\(ServerConfiguration.port)\(ServerConfiguration.websocketPath)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendMessage(_ message: MessageProtocol) {
        // String
//        guard let data = try? JSONEncoder().encode(message),
//              let jsonString = String(data: data, encoding: .utf8) else {
//            print("Failed to encode message")
//            return
//        }
//        socket.write(string: jsonString)
        
        
        // Data
        guard let data = try? JSONEncoder().encode(message) else {
            print("Failed to encode message")
            return
        }
        socket.write(data: data)
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("WebSocket connected: \(headers)")
        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason) with code: \(code)")
        case .text(let message):
            delegate?.didReceiveMessage(message)
        case .binary(let data):
            delegate?.didReceiveData(data)
        case .error(let error):
            print("WebSocket error: \(String(describing: error))")
        default:
            print("WebSocket: \(event)")
        }
    }
}
