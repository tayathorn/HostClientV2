//
//  HostServiceV2.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import Foundation
import Swifter

final class HostServiceV2 {
    static let shared = HostServiceV2()
    
    let server: HostServerV2
    
    private init(server: HostServerV2 = HostServerV2()) {
        self.server = server
    }

    func start() {
        server.start(port: UInt16(ServerConfiguration.port))
        setRules()
    }

    func stop() {
        server.stop()
    }
    
    func broadcast(message: EventMessageProtocol) {
        server.broadcast(message: message)
    }
}

private extension HostServiceV2 {
    func setRules() {
        let rules = HostControllerManagerV2.shared.actionHandlers.values.compactMap { messageHandler in
            return messageHandler as? HostServerRule
        }
        
        server.registerRules(rules)
    }
}
