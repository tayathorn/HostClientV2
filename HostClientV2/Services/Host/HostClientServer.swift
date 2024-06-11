//
//  HostClientServer.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

class HostClientServer {
    static let shared = HostClientServer()
    
    let server: HostServerV2
    
    init(server: HostServerV2 = HostServerV2()) {
        self.server = server
    }
    
    func start() {
        server.start(port: UInt16(ServerConfiguration.port))
    }

    func stop() {
        server.stop()
    }
    
    func broadcast(message: EventMessageProtocol) {
        server.broadcast(message: message)
    }
}
