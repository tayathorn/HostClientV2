//
//  HostServiceRegistry.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class HostServiceRegistry {
    static let shared = HostServiceRegistry()
    
    private var handlers: [MessageAction: any AnyHostHandlerProtocol] = [:]
    
    private init() {}
    
    func register<T: HostHandlerProtocol>(_ hostHandler: T) {
        let anyHostHandler = AnyHostHandler(hostHandler)
        handlers[hostHandler.action] = anyHostHandler
    }
    
    func resolve(action: MessageAction) -> AnyHostHandlerProtocol? {
        return handlers[action]
    }
    
    func removeAll() {
        handlers.removeAll()
    }
}
