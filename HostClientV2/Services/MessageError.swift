//
//  MessageError.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 11/6/2567 BE.
//

import Foundation

// TODO: Use error declared in FS?
enum MessageError: Error {
    case notFound
    case invalidURL
    case unableToDecode
    case noData
    case unexpected(error: Error)
    case responseError(urlResponse: HTTPURLResponse)
    case unknown
}
