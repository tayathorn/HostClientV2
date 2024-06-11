//
//  ClientServiceRegistry.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class ClientServiceRegistry {
    static let shared = ClientServiceRegistry()
    
    private var handlers: [MessageAction: ClientServiceProtocol] = [:]
    
    private init() {}
    
    func register(_ handler: ClientServiceProtocol) {
        handlers[handler.action] = handler
    }
    
    func resolve(action: MessageAction) -> ClientServiceProtocol? {
        handlers[action]
    }
    
    func allHandlers() -> [ClientServiceProtocol] {
        Array(handlers.values)
    }
    
    func removeAll() {
        handlers.removeAll()
    }
}
