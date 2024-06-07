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
        
        handleMessageAction(from: action.action, message: message)
    }

    func handleMessageAction(from action: MessageAction, message: Data) {
        let actionHandlers = HostControllerManagerV2.shared.actionHandlers

        if let handler = actionHandlers[action] {
            handler.handleReceive(message: message)
        }
    }
}
