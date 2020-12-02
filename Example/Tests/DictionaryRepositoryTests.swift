//
//  DictionaryRepositoryTests.swift
//  swagrTests
//
//  Created by peter on 2019/12/6.
//  Copyright © 2019 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class DictionaryRepositoryTests: XCTestCase {
    var repository: DictionaryRepository!
    
    override func setUp() {
        repository = DictionaryRepository()
    }

    override func tearDown() {
        repository.removeAll()
    }
    
    func testAppendAndRemove() {
        repository.append(key: "1", value: "A")
        XCTAssertTrue(repository.isContains("1"))
        repository.remove(key: "1")
        XCTAssertFalse(repository.isContains("1"))
    }

    func testAppendDuplicate() {
        repository.append(key: "1", value: "A")
        repository.append(key: "1", value: "B")
        XCTAssertTrue(repository.keys.count == 1)
        XCTAssertTrue(repository.isContains("1"))
        XCTAssertEqual(repository.object("1") as! String, "A")

        repository.removeAll()
        XCTAssertFalse(repository.isContains("1"))
    }

    func testCompareKeys() {
        repository.append(key: "1", value: "A")
        repository.append(key: "2", value: "B")
        repository.append(key: "3", value: "C")

        XCTAssertTrue(repository.isContains("1"))
        XCTAssertTrue(repository.isContains("2"))
        XCTAssertTrue(repository.isContains("3"))
        XCTAssertTrue(repository.keys.count == 3)
    }
    
    func testMultiThreadAccess() {
        repository.append(key: "1", value: 1)
        
        let expectation = self.expectation(description: "background access")
        expectation.expectedFulfillmentCount = 2
        DispatchQueue.global().async {
            self.repository.append(key: "1", value: 2)
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            self.repository.append(key: "2", value: 3)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(repository.values.count, 2)
    }
    
}
