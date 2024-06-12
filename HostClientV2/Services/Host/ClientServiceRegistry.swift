//
//  ClientServiceRegistry.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class ClientServiceRegistry {
    static let shared = ClientServiceRegistry()
    
    private var handlers: [MessageAction: any AnyClientServiceProtocol] = [:]
    
    private init() {}
    
    func register<T: ClientServiceProtocol>(_ service: T) {
        let anyService = AnyClientService(service)
        handlers[service.action] = anyService
    }
    
    func resolve(action: MessageAction) -> AnyClientServiceProtocol? {
        return handlers[action]
    }
    
    func removeAll() {
        handlers.removeAll()
    }
}
