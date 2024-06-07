//
//  CommandMessageProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

protocol CommandMessageProtocol: MessageProtocol {}

extension CommandMessageProtocol {
    var requestBody: Data? {
        let requestBody = try? JSONEncoder().encode(self)
        return requestBody
    }
}
