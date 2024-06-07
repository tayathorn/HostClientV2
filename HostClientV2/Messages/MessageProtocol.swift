//
//  MessageProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

protocol MessageProtocol: Codable {
    var action: MessageAction { get }
}
