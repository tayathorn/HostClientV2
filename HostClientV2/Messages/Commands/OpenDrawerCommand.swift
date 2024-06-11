//
//  OpenDrawerCommand.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import Foundation

struct OpenDrawerCommand: CommandMessageProtocol {
    var requestID: String
    var action: MessageAction = .openDrawer
    let amount: String
    let cashDrawerID: String
}
