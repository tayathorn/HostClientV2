//
//  OpenDrawerHandler.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class OpenDrawerHandler: HostHandlerProtocol {
    let action: MessageAction = .openDrawer
    let manager = HostControllerManagerV2.shared

    func handleSend(action: MessageAction) {
        let event = OpenDrawerEvent(amount: "450", cashDrawerID: "host-01", object: "star")
        hostService.broadcast(message: event)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: event)
    }
    
    func handlePath() {
        hostService.server.registerPostHandler(forPath: "/openDrawer") { [weak self] (message: OpenDrawerCommand) in
            self?.handleOpenDrawer(message: message)
            
            let response = CommandEmptyResponse()
            return .json(response)
        }
    }
}

private extension OpenDrawerHandler {
    func handleOpenDrawer(message: OpenDrawerCommand) {
        print("receive message: \(message)")
        let event = OpenDrawerEvent(amount: message.amount, cashDrawerID: message.cashDrawerID, object: "")
        hostService.broadcast(message: event)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: message)
    }
}
