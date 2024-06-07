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

    let hostService: HostServiceV2
    let clientService: ClientServiceV2
    
    private(set) var actionHandlers: [MessageAction: MessageHandler] = [:]
    private(set) var role: Role = .host
    
    var isHost: Bool {
        role == .host
    }

    private init(
        hostService: HostServiceV2 = HostServiceV2.shared,
        clientService: ClientServiceV2 = ClientServiceV2.shared
    ) {
        self.hostService = hostService
        self.clientService = clientService
    }

    func set(role: Role) {
        registerHandlers()
        
        self.role = role
        setupRole()
    }
}

private extension HostControllerManagerV2 {
    func setupRole() {
        switch role {
        case .host:
            hostService.start()
            clientService.disConnect()
        case .client:
            clientService.connect()
            hostService.stop()
        }
    }
    
    func registerHandlers() {
        let handlers: [MessageHandler] = [
            OpenDrawerHandler()
        ]
        
        handlers.forEach { handler in
            actionHandlers[handler.action] = handler
        }
    }
}
