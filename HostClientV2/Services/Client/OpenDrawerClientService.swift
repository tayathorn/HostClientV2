//
//  OpenDrawerClientService.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class OpenDrawerClientService: ClientServiceProtocol {
    var dataType: EventMessageProtocol.Type = OpenDrawerEvent.self
    
    let action: MessageAction = .openDrawer
    let manager = HostControllerManagerV2.shared
    
    func handleSend(action: MessageAction) {
        let command = OpenDrawerCommand(amount: "123", cashDrawerID: "client")
        clientService.performRequest(path: "/openDrawer", command: command) { (result: Result<CommandEmptyResponse, Error>) in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func handleReceive(event: EventMessageProtocol) {
        guard let openDrawerEvent = event as? OpenDrawerEvent else {
            print("Invalid event type")
            return
        }
        handle(event: openDrawerEvent)
    }
}

private extension OpenDrawerClientService {
    func handle(event: OpenDrawerEvent) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: event)
    }
}
