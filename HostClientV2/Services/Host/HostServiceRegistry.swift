//
//  HostServiceRegistry.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class HostServiceRegistry {
    static let shared = HostServiceRegistry()
    
    private var handlers: [MessageAction: HostHandlerProtocol] = [:]
    
    private init() {}
    
    func register(_ handler: HostHandlerProtocol) {
        handlers[handler.action] = handler
    }
    
    func resolve(action: MessageAction) -> HostHandlerProtocol? {
        handlers[action]
    }
    
    func allHandlers() -> [HostHandlerProtocol] {
        Array(handlers.values)
    }
    
    func removeAll() {
        handlers.removeAll()
    }
}
