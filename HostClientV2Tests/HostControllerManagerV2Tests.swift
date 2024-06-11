//
//  HostControllerManagerV2Tests.swift
//  HostClientV2Tests
//
//  Created by Tayathorn.p on 11/6/2567 BE.
//

import XCTest
@testable import HostClientV2

class MockHostClientConnector: HostClientConnector {
    var performRequestCalled = false
    var performRequestCommand: CommandMessageProtocol?
    
    override func performRequest<T: Decodable>(command: CommandMessageProtocol, completion: @escaping (Result<T, MessageError>) -> Void) {
        performRequestCalled = true
        performRequestCommand = command
    }
}

class MockHostClientServer: HostClientServer {
    var broadcastCalled = false
    var broadcastedMessage: EventMessageProtocol?

    override func broadcast(message: EventMessageProtocol) {
        broadcastCalled = true
        broadcastedMessage = message
    }
}


final class HostControllerManagerV2Tests: XCTestCase {
    var sut: HostControllerManagerV2!
    var mockHostClientConnector: MockHostClientConnector!
    var mockHostClientServer: MockHostClientServer!
    
    let hostRegistry = HostServiceRegistry.shared
    let clientRegistry = ClientServiceRegistry.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockHostClientConnector = MockHostClientConnector()
        mockHostClientServer = MockHostClientServer()
        
        sut = HostControllerManagerV2(
            hostService: mockHostClientServer,
            hostRegistry: hostRegistry,
            clientService: mockHostClientConnector,
            clientRegistry: clientRegistry
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockHostClientConnector = nil
        mockHostClientServer = nil
        
        try super.tearDownWithError()
    }
    
    func test_OpenDrawer_As_Host_ShouldBroadcast() {
        sut.set(role: .host)
        
        let openDrawerHandler = OpenDrawerHandler(manager: sut)
        hostRegistry.register(openDrawerHandler)
        
        sut.openDrawer(id: "001", amount: "100")
        
        XCTAssertTrue(mockHostClientServer.broadcastCalled)
        
        let event = mockHostClientServer.broadcastedMessage as? OpenDrawerEvent
        XCTAssertEqual(event?.cashDrawerID, "001")
        XCTAssertEqual(event?.amount, "100")
    }
    
    func test_OpenDrawer_As_Client_ShouldSendCommand() {
        sut.set(role: .client)
        
        sut.openDrawer(id: "002", amount: "200")
        
        XCTAssertTrue(mockHostClientConnector.performRequestCalled)
        
        let command = mockHostClientConnector.performRequestCommand as? OpenDrawerCommand
        XCTAssertEqual(command?.cashDrawerID, "002")
        XCTAssertEqual(command?.amount, "200")
    }
    
}
