//
//  MessageActionChecker.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 11/6/2567 BE.
//

struct MessageActionChecker {
    static func isEnabled(action: MessageAction) -> Bool {
        switch action {
        case .openDrawer:
            return true
        }
    }
}
