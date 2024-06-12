//
//  OpenDrawerHandler.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

class OpenDrawerHandler: HostHandlerProtocol {
    typealias Command = OpenDrawerCommand
    
    let action: MessageAction = .openDrawer
    let manager: HostControllerManagerV2
    
    init(manager: HostControllerManagerV2 = HostControllerManagerV2.shared) {
        self.manager = manager
    }
    
    func handle(command: OpenDrawerCommand) -> ServerResponse {
        handleOpenDrawer(message: command)
        
        let response = CommandEmptyResponse()
        return .json(response)
    }
    
    func handleOpenDrawer(message: OpenDrawerCommand) {
        print("receive message: \(message)")
        DomainLogic.shared.mutateOpenDrawer(
            id: message.cashDrawerID,
            amount: message.amount
        )
        
        let event = OpenDrawerEvent(
            amount: message.amount,
            cashDrawerID: message.cashDrawerID,
            object: ""
        )
        hostService.broadcast(message: event)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: message)
    }
}

// Mutate
final class DomainLogic {
    static let shared = DomainLogic()
    
    func mutateOpenDrawer(id: String, amount: String) {
        // mutate1
        // mutate2
        // mutate3
    }
}
