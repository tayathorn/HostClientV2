//
//  MessageHandler.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

import Foundation

protocol MessageHandler: MessageParserHandler {
    var manager: HostControllerManagerV2 { get }
    var action: MessageAction { get }
}


extension MessageHandler {
    var hostService: HostServiceV2 {
        manager.hostService
    }

    var clientService: ClientServiceV2 {
        manager.clientService
    }
}

