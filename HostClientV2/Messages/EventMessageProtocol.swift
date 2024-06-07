//
//  EventMessageProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

protocol EventMessageProtocol: MessageProtocol {}

extension EventMessageProtocol {
    var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return jsonString
    }
    
    var jsonBinary: [UInt8]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return [UInt8](data)
    }
}
