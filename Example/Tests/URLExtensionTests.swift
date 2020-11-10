//
//  URLExtensionTests.swift
//  swagTests
//
//  Created by Mike Yu on 10/11/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class URLExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingQueryItems() {
        let url = URL(string: "https://www.example.com")
        
        XCTAssertNotNil(url?.addingQueryItems(["w":"120"]))
        XCTAssertEqual(url?.addingQueryItems(["w":"120"]), URL(string: "https://www.example.com?w=120"))
    }
    
    func testAddingQueryItemsInSequence() {
        let url = URL(string: "https://www.example.com")
        
        let result = url?.addingQueryItems(["w":"120"])?.addingQueryItems(["h":"100"])
        
        XCTAssertNotNil(result)
        if let result = result {
            let comp = URLComponents(url: result, resolvingAgainstBaseURL: false)
            XCTAssertNotNil(comp)
            XCTAssertEqual(comp, URLComponents(string: "https://www.example.com?w=120&h=100"))
        }
    }
    
    func testAddingMultipleQueryItems() {
        let url = URL(string: "https://www.example.com")
        
        let result = url?.addingQueryItems(["w":"120", "h":"100"])
        
        XCTAssertNotNil(result)
        if let result = result {
            let comp = URLComponents(url: result, resolvingAgainstBaseURL: false)
            XCTAssertNotNil(comp)
            XCTAssertEqual(comp?.queryItems?.count, 2)
        }
    }
    
    func testBuildQueryItems() {
        
        let queryItems = URL(string: "http://swag.live/")?.buildQueryItems(fromDictionary: ["STRING":"STRING", "NSNUMBER": NSNumber(value: 100), "INT": 100])
        
        XCTAssertEqual(queryItems?.count, 3)
        
        let queryItem1 = URL(string: "http://swag.live/")?.buildQueryItems(fromDictionary: ["STRING":"STRING"])
        XCTAssertEqual(queryItem1?.count, 1)
        XCTAssertEqual(queryItem1?.first?.name, "STRING")
        XCTAssertEqual(queryItem1?.first?.value, "STRING")
        
        let queryItem2 = URL(string: "http://swag.live/")?.buildQueryItems(fromDictionary: ["NSNUMBER": NSNumber(value: 100)])
        XCTAssertEqual(queryItem2?.count, 1)
        
        XCTAssertEqual(queryItem2?.first?.name, "NSNUMBER")
        XCTAssertEqual(queryItem2?.first?.value, "100")
        
        let queryItem3 = URL(string: "http://swag.live/")?.buildQueryItems(fromDictionary: ["INT": 100])
        XCTAssertEqual(queryItem3?.count, 1)
        XCTAssertEqual(queryItem3?.first?.name, "INT")
        XCTAssertEqual(queryItem3?.first?.value, "100")
        
    }
    
    func testAppendingQueryParametersResult() {
        let url = URL(string: "https://swag.live/query")?.appendingQueryParameters(["num": NSNumber(value: 100)])
        
        XCTAssertEqual(url?.absoluteString, "https://swag.live/query?num=100")
    }
    
    func testAddingQueryItemsResult() {
        let url = URL(string: "https://swag.live/query")?.addingQueryItems(["k":"v"])
        XCTAssertEqual(url?.absoluteString, "https://swag.live/query?k=v")
        
    }

}
