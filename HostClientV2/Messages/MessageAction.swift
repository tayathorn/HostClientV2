//
//  MessageAction.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 6/6/2567 BE.
//

enum MessageAction: String, Codable {
    case openDrawer = "open-drawer"
    
    var path: String {
        "/\(self.rawValue)"
    }
}

struct CommandEmptyResponse: Codable {}

