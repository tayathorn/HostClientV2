//
//  OpenDrawerEvent.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

struct OpenDrawerEvent: EventMessageProtocol {
    var action: MessageAction = .openDrawer
    
    let amount: String
    let cashDrawerID: String
    let object: String
}
