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
    let repository = DictionaryRepository()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
}
