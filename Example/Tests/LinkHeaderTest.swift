//
//  LinkHeaderTest.swift
//  swagTests
//
//  Created by Hokila Jan on 2019/1/25.
//  Copyright © 2019 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class LinkHeaderTest: XCTestCase {
    
    var linkString:String = ""
    
    var response:HTTPURLResponse {
        let url = URL(string: "http://")!
        let headerFields:[String:String] = ["Link":self.linkString]
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headerFields)!
    }
    
    func testInit() {
        self.linkString = """
        <https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=2&limit=10>; rel="next", <https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=10&limit=10>; rel="last"
        """
        XCTAssertNotNil(LinkHeader(response: self.response))
        
        self.linkString = ""
        XCTAssertNil(LinkHeader(response: self.response))
        
        let response = HTTPURLResponse(url: URL(string: "http://")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        XCTAssertNil(LinkHeader(response: response))
    }
    
    func testNext() {
        self.linkString = """
        <https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=2&limit=10>; rel="next", <https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=10&limit=10>; rel="last"
        """
        let header = LinkHeader(response: self.response)
        XCTAssertEqual(header?.next?.absoluteString, "https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=2&limit=10")
        XCTAssertEqual(header?.last?.absoluteString, "https://api.swag.live/feeds/5c48493003c47f6a1464b314?page=10&limit=10")
        XCTAssertEqual(header?.first, nil)
        XCTAssertEqual(header?.prev, nil)
    }
    
    func testAllField() {
        self.linkString = """
        <https://api.swag.live/inbox?since=1549881511&page=1&limit=20>; rel="first", <https://api.swag.live/inbox?since=1549881511&page=1&limit=20>; rel="prev", <https://api.swag.live/inbox?since=1549881511&page=3&limit=20>; rel="next", <https://api.swag.live/inbox?since=1549881511&page=18&limit=20>; rel="last"
        """
        
        let header = LinkHeader(response: self.response)
        XCTAssertEqual(header?.next?.absoluteString, "https://api.swag.live/inbox?since=1549881511&page=3&limit=20")
        XCTAssertEqual(header?.last?.absoluteString, "https://api.swag.live/inbox?since=1549881511&page=18&limit=20")
        XCTAssertEqual(header?.first?.absoluteString, "https://api.swag.live/inbox?since=1549881511&page=1&limit=20")
        XCTAssertEqual(header?.prev?.absoluteString, "https://api.swag.live/inbox?since=1549881511&page=1&limit=20")
    }
    
}
