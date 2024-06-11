//
//  CommandMessageProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

protocol CommandMessageProtocol: MessageProtocol {
    var requestID: String { get }
}

extension CommandMessageProtocol {
    var path: String {
        action.path
    }
}
