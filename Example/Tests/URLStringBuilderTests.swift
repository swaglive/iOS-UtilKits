//
//  URLStringBuilderTests.swift
//  schatTests
//
//  Created by peter on 2020/2/25.
//  Copyright © 2020 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class URLStringBuilderTests: XCTestCase {
    let baseURL = "https://api.swag.live"
    func testBase() {
        let url = URLStringBuilder(urlString: baseURL)
            .string
        XCTAssertEqual(url, baseURL)
    }
    
    func testCustomBase() {
        let url = URLStringBuilder(urlString: "https://api.v2.swag.live").string
        XCTAssertEqual(url, "https://api.v2.swag.live")
    }
    
    func testPath() {
        let url = URLStringBuilder(urlString: baseURL)
            .path("me")
            .string
        XCTAssertEqual(url, "https://api.swag.live/me")
    }
    
    func testMultiplePaths() {
        let url = URLStringBuilder(urlString: baseURL)
            .path("me")
            .path("followers").string
        XCTAssertEqual(url, "https://api.swag.live/me/followers")
    }
    
    func testExtension() {
        let url = URLStringBuilder(urlString: baseURL)
            .path("test")
            .extension("json").string
        XCTAssertEqual(url, "https://api.swag.live/test.json")
    }
    
    func testParameter() {
        let url = URLStringBuilder(urlString: baseURL)
            .query(key: "type", value: "story")
            .string
        XCTAssertEqual(url, "https://api.swag.live?type=story")
    }
    
    func testParameters() {
        let url = URLStringBuilder(urlString: baseURL)
            .query(key: "type", value: "story")
            .query(key: "key", value: "value")
            .string
        XCTAssertEqual(url, "https://api.swag.live?key=value&type=story")
    }
    
    func testPathParameter() {
        let url = URLStringBuilder(urlString: baseURL)
            .path("me")
            .query(key: "type", value: "story")
            .string
        XCTAssertEqual(url, "https://api.swag.live/me?type=story")
    }
    
    func testCombination() {
        let url = URLStringBuilder(urlString: baseURL)
            .path("me")
            .path("unlocked-users")
            .query(key: "type", value: "story")
            .string
        
        XCTAssertEqual(url, "https://api.swag.live/me/unlocked-users?type=story")
    }
    func testTwoPart() {
         var builder = URLStringBuilder(urlString: baseURL)
            .path("me")
            .path("unlocked-users")
        
        builder = builder.query(key: "type", value: "story")
        let url = builder.string
        
        XCTAssertEqual(url, "https://api.swag.live/me/unlocked-users?type=story")
    }
    func testTwoQueriesWithSameName() {
        let url = URLStringBuilder(urlString: baseURL)
            .query(key: "key1", value: "value1")
            .query(key: "key1", value: "value2")
            .string
        XCTAssertEqual(url, "https://api.swag.live?key1=value1&key1=value2")
    }
}
