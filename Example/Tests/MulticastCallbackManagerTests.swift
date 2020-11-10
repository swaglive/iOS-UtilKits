//
//  MulticastCallbackManagerTests.swift
//  swagTests
//
//  Created by Mike Yu on 28/09/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class MulticastCallbackManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvokeWithoutArgument() {
        let manager = MulticastCallbackManager<()->()>()
        var counter = 0
        _ = manager.add{ counter += 1 }
        
        manager.invokeEach{$0()}
        
        XCTAssertEqual(counter, 1)
    }
    
    func testMultipleInvocations() {
        let manager = MulticastCallbackManager<()->()>()
        var counter1 = 0
        var counter2 = 0
        _ = manager.add{ counter1 += 1 }
        _ = manager.add{ counter2 += 1 }

        manager.invokeEach{$0()}
        
        XCTAssertEqual(counter1, 1)
        XCTAssertEqual(counter2, 1)
    }
    
    func testInvokeWithArgument() {
        let manager = MulticastCallbackManager<(String)->()>()
        var value = "apple"
        _ = manager.add{value = $0}
        
        manager.invokeEach{$0("banana")}
        
        XCTAssertEqual(value, "banana")
    }
    
    func testRemoval() {
        let manager = MulticastCallbackManager<()->()>()
        var counter1 = 0
        var counter2 = 0
        let token1 = manager.add{ counter1 += 1 }
        _ = manager.add{ counter2 += 1 }
        
        manager.invokeEach{$0()}
        manager.remove(with: token1)
        manager.invokeEach{$0()}
        
        XCTAssertEqual(counter1, 1)
        XCTAssertEqual(counter2, 2)
    }
    
    func testRemovalFromOutside() {
        let manager = MulticastCallbackManager<()->()>()
        var counter = 0
        let token = manager.add{ counter += 1 }
        
        manager.invokeEach{$0()}
        token.unregister()
        manager.invokeEach{$0()}
        
        XCTAssertEqual(counter, 1)
    }
    
    func testAutoRemoval() {
        let manager = MulticastCallbackManager<()->()>()
        var counter1 = 0
        var counter2 = 0
        var token1: MulticastCallbackRegistration? = manager.addAutoRemovingHandler{ counter1 += 1 }
        _ = manager.addAutoRemovingHandler{ counter2 += 1 }
        
        manager.invokeEach{$0()}
        token1 = nil
        manager.invokeEach{$0()}
        
        XCTAssertEqual(counter1, 1)
        XCTAssertEqual(counter2, 0)
    }
    
    func testIsEmpty() {
        let manager = MulticastCallbackManager<()->()>()
        XCTAssertTrue(manager.isEmpty)
        
        let token = manager.add{ }
        XCTAssertFalse(manager.isEmpty)
        
        manager.remove(with: token)
        XCTAssertTrue(manager.isEmpty)
    }
}
