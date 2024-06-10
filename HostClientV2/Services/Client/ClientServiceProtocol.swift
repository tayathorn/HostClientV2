//
//  ClientServiceProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

protocol ClientServiceProtocol: HostClientServiceProtocol {
    var action: MessageAction { get }
    var dataType: EventMessageProtocol.Type { get }
    
    func handleReceive(event: EventMessageProtocol)
}
