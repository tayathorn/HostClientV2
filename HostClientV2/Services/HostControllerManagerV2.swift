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

// TODO: Reminder handle when integrate objc
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
    
    init(
        hostService: HostClientServer = HostClientServer.shared,
        hostRegistry: HostServiceRegistry = HostServiceRegistry.shared,
        clientService: HostClientConnector = HostClientConnector.shared,
        clientRegistry: ClientServiceRegistry = ClientServiceRegistry.shared
    ) {
        self.hostService = hostService
        self.hostRegistry = hostRegistry
        
        self.clientService = clientService
        self.clientRegistry = clientRegistry
    }

    func set(role: Role) {
        self.role = role
        setupRole()
    }
    
    func isSupportV2(for action: MessageAction) -> Bool {
        guard AppFeatureFlagManager.shared.isEnable(type: .hostClientV2) else {
            return false
        }

        return MessageActionChecker.isEnabled(action: action)
    }
    
    // beware type cast.
    func openDrawer(id: String, amount: String) {
        let generateID = "001"
        let command = OpenDrawerCommand(requestID: generateID, amount: amount, cashDrawerID: id)
        
        if isHost {
            let registry = hostRegistry.resolve(action: command.action) as? OpenDrawerHandler
            registry?.handleOpenDrawer(message: command)
        } else {
            clientService.performRequest(command: command) { (result: Result<CommandEmptyResponse, MessageError>) in
                
            }
        }
    }
}

private extension HostControllerManagerV2 {
    func setupRole() {
        switch role {
        case .host:
            registerHostHandlers()
            hostService.start()
            
            clientService.disConnect()
            clientRegistry.removeAll()
        case .client:
            registerClientServices()
            clientService.connect()
            
            hostService.stop()
            hostRegistry.removeAll()
        }
    }
    
    func registerHostHandlers() {
        let handlers = [
            OpenDrawerHandler()
        ]
        
        handlers.forEach { 
            HostServiceRegistry.shared.register($0)
            hostService.server.register(for: $0.action)
        }
    }
    
    func registerClientServices() {
        let services = [
            OpenDrawerClientService()
        ]
        services.forEach { ClientServiceRegistry.shared.register($0) }
    }
}
