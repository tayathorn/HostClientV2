//
//  AppFeatureFlagManager.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 11/6/2567 BE.
//

enum FeatureFlagType {
    case hostClientV2
}

final class AppFeatureFlagManager {
    static let shared = AppFeatureFlagManager()
    
    public func isEnable(type: FeatureFlagType) -> Bool {
        switch type {
        case .hostClientV2:
            return true
        }
    }
}

