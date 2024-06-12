//
//  ClientServiceProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

protocol ClientServiceProtocol: HostClientServiceProtocol {
    associatedtype Event: EventMessageProtocol
    var action: MessageAction { get }
    
    func handleReceive(event: Event)
}

extension ClientServiceProtocol {
    var dataType: EventMessageProtocol.Type {
        Event.self
    }
}

/// `AnyClientServiceProtocol` serves as a type-erased wrapper protocol for `ClientServiceProtocol`.
/// It allows storing heterogeneous collections of services in `ClientServiceRegistry` without exposing the generic type.
protocol AnyClientServiceProtocol {
    var action: MessageAction { get }
    var dataType: EventMessageProtocol.Type { get }

    func handleReceive(event: EventMessageProtocol)
}

/// `AnyClientService` is a concrete implementation of `AnyClientServiceProtocol`,
/// serving as a type-erased wrapper for any `ClientServiceProtocol` instance.
struct AnyClientService<T: ClientServiceProtocol>: AnyClientServiceProtocol {
    private let _handleReceive: (EventMessageProtocol) -> Void

    var action: MessageAction
    var dataType: EventMessageProtocol.Type

    init(_ service: T) {
        self.action = service.action
        self.dataType = service.dataType
        self._handleReceive = { event in
            if let event = event as? T.Event {
                service.handleReceive(event: event)
            } else {
                print("Invalid event type")
            }
        }
    }

    func handleReceive(event: EventMessageProtocol) {
        _handleReceive(event)
    }
}

