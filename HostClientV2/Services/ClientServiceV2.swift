//
//  ClientServiceV2.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import Foundation
import Starscream

final class ClientServiceV2 {
    static let shared = ClientServiceV2()
    
    let webSocketClient: WebSocketClient
    
    init(webSocketClient: WebSocketClient = WebSocketClient()) {
        self.webSocketClient = webSocketClient
        webSocketClient.delegate = self
    }
    
    func connect() {
        webSocketClient.connect()
    }
    
    func disConnect() {
        webSocketClient.disconnect()
    }
    
    // Convert to enum API?
    func send<T: Decodable>(path: String, command: CommandMessageProtocol, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "http://\(ServerConfiguration.ip):\(ServerConfiguration.port)\(path)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: command.requestBody) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(NSError(domain: "Server error", code: -1, userInfo: nil)))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func sendMessage(_ message: MessageProtocol) {
        webSocketClient.sendMessage(message)
    }
}

extension ClientServiceV2: WebSocketClientDelegate {
    func didReceiveMessage(_ message: String) {
        print("didReceiveMessage")
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        MessageParser.shared.parse(data)
    }
    
    func didReceiveData(_ data: Data) {
        print("didReceiveData")
        MessageParser.shared.parse(data)
    }
}
