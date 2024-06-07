//
//  OpenDrawerHandler.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import Foundation

final class OpenDrawerHandler: MessageHandler {
    let action: MessageAction = .openDrawer
    let manager = HostControllerManagerV2.shared

    func handleSend(useSocket: Bool) {
        switch manager.role {
        case .host:
            let message = OpenDrawerEvent(amount: "450", cashDrawerID: "host-01", object: "star")
            hostSocketSend(message: message)
        case .client:
            if useSocket {
                clientSocketSend()
            } else {
                clientServerSend()
            }
        }
    }
    
    func handleReceive(message: Data) {
        switch manager.role {
        case .host:
            guard let openDrawer = decodeMessage(type: OpenDrawerCommand.self, from: message) else {
                return
            }
            
            hostSocketSend(message: .init(amount: openDrawer.amount, cashDrawerID: openDrawer.cashDrawerID, object: ""))
        case .client:
            guard let openDrawer = decodeMessage(type: OpenDrawerEvent.self, from: message) else {
                return
            }
            
            clientSocketReceive(message: openDrawer)
        }
    }
}

private extension OpenDrawerHandler {
    func hostSocketSend(message: OpenDrawerEvent) {
        print("broadcast")
        hostService.broadcast(message: message)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: message)
    }

    func clientServerSend() {
        let command = OpenDrawerCommand(amount: "200", cashDrawerID: "client-01")
        
        clientService.send(path: "/openDrawer", command: command) { (result: Result<CommandEmptyResponse, Error>) in
            switch result {
                case .success:
                    print("success")
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
    }
    
    func clientSocketSend() {
        let command = OpenDrawerCommand(amount: "200", cashDrawerID: "client-socket-01")
        clientService.sendMessage(command)
    }

    func hostServerReceive(message: OpenDrawerCommand) {
        print("receive message: \(message)")
        hostSocketSend(message: .init(amount: message.amount, cashDrawerID: message.cashDrawerID, object: ""))
    }

    func clientSocketReceive(message: OpenDrawerEvent) {
        print("clientSocketReceive: \(message)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: message)
    }
}

extension OpenDrawerHandler: HostServerRule {
    func registerPathHandler() {
        hostService.server.addPostHandler(forPath: "/openDrawer") { [weak self] (message: OpenDrawerCommand) in
            self?.hostServerReceive(message: message)
            
            let response = CommandEmptyResponse()
            return .json(response)
        }
    }
}
