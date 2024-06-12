//
//  OpenDrawerClientService.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

import Foundation

final class OpenDrawerClientService: ClientServiceProtocol {
    typealias Event = OpenDrawerEvent
    
    let action: MessageAction = .openDrawer
    let manager = HostControllerManagerV2.shared
    
    func handleReceive(event: OpenDrawerEvent) {
        DomainLogic.shared.mutateOpenDrawer(
            id: event.cashDrawerID,
            amount: event.amount
        )
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_UI") , object: event)
    }
}
