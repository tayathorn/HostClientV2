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
    
    func handleReceive(event: EventMessageProtocol) {
        guard let openDrawerEvent = event as? OpenDrawerEvent else {
            print("Invalid event type")
            return
        }
        
        DomainLogic.shared.mutateOpenDrawer(
            id: openDrawerEvent.cashDrawerID,
            amount: openDrawerEvent.amount
        )
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: event)
    }
}
