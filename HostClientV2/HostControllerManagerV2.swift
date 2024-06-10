//
//  HostControllerManagerV2.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

enum Role: String {
    case host
    case client
}

final class HostControllerManagerV2 {
    static let shared = HostControllerManagerV2()
    
    let hostService: HostClientServer
    let hostRegistry: HostServiceRegistry
    
    let clientService: HostClientConnector
    let clientRegistry: ClientServiceRegistry
    
    private(set) var role: Role = .host
    
    var isHost: Bool {
        role == .host
    }
    
    private init(hostService: HostClientServer = HostClientServer.shared,
                 hostRegistry: HostServiceRegistry = HostServiceRegistry.shared,
                 clientService: HostClientConnector = HostClientConnector.shared,
                 clientRegistry: ClientServiceRegistry = ClientServiceRegistry.shared) {
        self.hostService = hostService
        self.hostRegistry = hostRegistry
        
        self.clientService = clientService
        self.clientRegistry = clientRegistry
    }

    func set(role: Role) {
        self.role = role
        setupRole()
    }
    
    func handleSend(for action: MessageAction) {
        if isHost {
            let host = hostRegistry.resolve(action: action)
            host?.handleSend(action: action)
        } else {
            let client = clientRegistry.resolve(action: action)
            client?.handleSend(action: action)
        }
    }
}

private extension HostControllerManagerV2 {
    func setupRole() {
        switch role {
        case .host:
            hostService.registerHandlers()
            hostService.start()
            clientService.disConnect()
        case .client:
            clientService.registerServices()
            clientService.connect()
            hostService.stop()
        }
    }
}
