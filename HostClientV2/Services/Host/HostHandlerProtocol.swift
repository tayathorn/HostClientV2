//
//  HostHandlerProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

protocol HostHandlerProtocol: HostClientServiceProtocol {
    var action: MessageAction { get }
    
    func handlePath()
}

