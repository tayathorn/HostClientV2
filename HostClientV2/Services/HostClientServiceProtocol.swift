//
//  HostClientServiceProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

protocol HostClientServiceProtocol {
    var manager: HostControllerManagerV2 { get }
    
    func handleSend(action: MessageAction)
}

extension HostClientServiceProtocol {
    var hostService: HostClientServer {
        manager.hostService
    }

    var clientService: HostClientConnector {
        manager.clientService
    }
}
