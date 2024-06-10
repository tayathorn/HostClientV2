//
//  MessageParser.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

final class MessageParser {
    static let shared = MessageParser()

    func parse(_ message: Data) {
        let decoder = JSONDecoder()
        guard let action = try? decoder.decode(AnyMessage.self, from: message) else {
            return
        }
        
        handleMessage(for: action.action, message: message)
    }

    func handleMessage(for action: MessageAction, message: Data) {
        guard let handler = ClientServiceRegistry.shared.resolve(action: action) else {
            print("No handler found for action: \(action)")
            return
        }
        
        let decoder = JSONDecoder()
        if let event = try? decoder.decode(handler.dataType, from: message) {
            handler.handleReceive(event: event)
        }
    }
}
