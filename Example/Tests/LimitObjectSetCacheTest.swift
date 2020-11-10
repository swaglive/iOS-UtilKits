//
//  LimitObjectSetCacheTest.swift
//  swagTests
//
//  Created by peter on 2019/1/23.
//  Copyright © 2019 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class LimitObjectSetCacheTest: XCTestCase {

    func testAddObject() {
        let cache = LimitObjectSetCache<String>(limit: 3)
        cache.add("1")
        XCTAssertTrue(cache.contains("1"))
        XCTAssertEqual(cache.count, 1)

        cache.add("2")
        cache.add("3")
        XCTAssertEqual(cache.count, 3)
    }
    
    func testAddDuplicate() {
        let cache = LimitObjectSetCache<String>(limit: 3)
        cache.add("1")
        XCTAssertEqual(cache.count, 1)
        cache.add("1")
        XCTAssertEqual(cache.count, 1)
        cache.add("2")
        XCTAssertEqual(cache.count, 2)
    }
    
    func testOverLimit() {
        let cache = LimitObjectSetCache<String>(limit: 3)
        cache.add("1")
        cache.add("2")
        cache.add("3")
        cache.add("4")
        XCTAssertEqual(cache.count, 3)
        
        XCTAssertFalse(cache.contains("1"))
        let objects = cache.objects
        XCTAssertEqual(objects[0], "2")
        XCTAssertEqual(objects[1], "3")
        XCTAssertEqual(objects[2], "4")

    }
}
