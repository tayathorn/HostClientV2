//
//  HostHandlerProtocol.swift
//  HostClientV2
//
//  Created by Tayathorn.p on 10/6/2567 BE.
//

protocol HostHandlerProtocol: HostClientServiceProtocol {
    associatedtype Command: CommandMessageProtocol
    var action: MessageAction { get }
    
    func handle(command: Command) -> ServerResponse
}

extension HostHandlerProtocol {
    var dataType: CommandMessageProtocol.Type {
        Command.self
    }
}

/// `AnyHostHandlerProtocol` serves as a type-erased wrapper protocol for `HostHandlerProtocol`.
/// It allows storing heterogeneous collections of services in `HostServiceRegistry` without exposing the generic type.
protocol AnyHostHandlerProtocol {
    var action: MessageAction { get }
    var dataType: CommandMessageProtocol.Type { get }

    func handle(command: CommandMessageProtocol) -> ServerResponse
}

/// `AnyHostHandler` is a concrete implementation of `AnyHostHandlerProtocol`,
/// serving as a type-erased wrapper for any `HostHandlerProtocol` instance.
struct AnyHostHandler<T: HostHandlerProtocol>: AnyHostHandlerProtocol {
    var dataType: CommandMessageProtocol.Type
    
    private let _handle: (_ command: CommandMessageProtocol) -> ServerResponse

    var action: MessageAction

    init(_ handler: T) {
        self.action = handler.action
        self.dataType = handler.dataType
        self._handle = { command in
            if let command = command as? T.Command {
                return handler.handle(command: command)
            } else {
                print("Invalid command")
                return .badRequest(nil)
            }
        }
    }
    
    func handle(command: CommandMessageProtocol) -> ServerResponse {
        _handle(command)
    }
}

