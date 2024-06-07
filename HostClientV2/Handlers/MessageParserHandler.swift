//
//  MessageParserHandler.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 7/6/2567 BE.
//

import Foundation

protocol MessageParserHandler {
    func handleReceive(message: Data)
}

extension MessageParserHandler {
    func decodeMessage<T: Decodable>(type: T.Type, from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            print("Failed to decode message: \(error)")
            return nil
        }
    }
}
