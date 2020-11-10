//
//  RFC1123FormatterTest.swift
//  swagTests
//
//  Created by peter on 2018/6/14.
//  Copyright © 2018年 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class RFC1123FormatterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRFC1123Formatter() {
        let dateFormatter = DateFormatter.rfc1123()
        let lastModifiedDate = dateFormatter.date(from: "Mon, 11 Jun 2018 10:30:40 GMT")
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        
        let year = calendar.component(.year, from: lastModifiedDate!)
        let month = calendar.component(.month, from: lastModifiedDate!)
        let day = calendar.component(.day, from: lastModifiedDate!)
        let hour = calendar.component(.hour, from: lastModifiedDate!)
        let minute = calendar.component(.minute, from: lastModifiedDate!)
        let second = calendar.component(.second, from: lastModifiedDate!)
        
        
        XCTAssertTrue(year == 2018)
        XCTAssertTrue(month == 6)
        XCTAssertTrue(day == 11)
        XCTAssertTrue(hour == 10)
        XCTAssertTrue(minute == 30)
        XCTAssertTrue(second == 40)
    }
}
