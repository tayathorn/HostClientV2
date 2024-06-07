//
//  HostServerV2.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation
import Swifter

struct Message: Codable {
    let action: String
    let content: String
}

final class HostServerV2 {
    private let server = HttpServer()
    private var webSockets: [WebSocketSession] = []
    
    private var rules: [HostServerRule] = []

    func start(port: UInt16) {
        server[ServerConfiguration.websocketPath] = websocket(text: { [weak self] _, text in
            let data = Data(text.utf8)
            self?.handleWebsocketMessage(data: Data(data))
        }, binary: { [weak self] _, data in
            self?.handleWebsocketMessage(data: Data(data))
        }, connected: { [weak self] session in
            print("connected session: \(session)")
            let isContain = self?.webSockets.contains(where: { $0 == session }) ?? false
            if !isContain {
                self?.webSockets.append(session)
            }
        })
        
        do {
            try server.start(port)
            print("HTTP server has started on port \(port). Try to connect now...")
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func registerRules(_ rules: [HostServerRule]) {
        self.rules = rules
        
        for rule in rules {
            rule.registerPathHandler()
        }
    }
    
    func stop() {
        server.stop()
    }
    
    func broadcast(message: EventMessageProtocol) {
        if let binary = message.jsonBinary {
            for session in webSockets {
                session.writeBinary(binary)
            }
        }
    }
    
    func addPostHandler<T: Decodable>(forPath path: String, handler: @escaping (T) -> HttpResponse) {
        server.post["\(path)"] = { request in
            let bodyData = Data(request.body)
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: bodyData)
                return handler(decodedObject)
            } catch {
                print("Failed to decode JSON: \(error)")
                return .badRequest(nil)
            }
        }
    }
}

private extension HostServerV2 {
    func handleWebsocketMessage(data: Data) {
        MessageParser.shared.parse(data)
    }
}


extension HttpResponse {
    static func json<T: Codable>(_ object: T) -> HttpResponse {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(object)
            return .ok(.data(jsonData, contentType: "application/json"))
        } catch {
            print("Failed to encode JSON: \(error)")
            return .internalServerError
        }
    }
}
