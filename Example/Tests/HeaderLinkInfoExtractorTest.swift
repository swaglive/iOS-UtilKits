//
//  HeaderLinkInfoExtractorTest.swift
//  swagTests
//
//  Created by peter on 2018/3/29.
//  Copyright © 2018年 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class HeaderLinkInfoExtractorTest: XCTestCase {
    
    func testExtractLinksSuccess() {
        let extractor = HeaderLinkInfoExtractor()
        let linkStrings = """
<https://api.swag.live/me>; rel="user", <swag://user/birthdate>; rel="birthdate"
"""
        let result = extractor.extract(fromString: linkStrings)

        XCTAssertTrue(result.count == 2)
        XCTAssertEqual(result["user"], "https://api.swag.live/me")
        XCTAssertEqual(result["birthdate"], "swag://user/birthdate")
    }
    
    func testExtractLinkElementsSuccess() {
        let extractor = HeaderLinkInfoExtractor()
        let linkStrings = """
<https://api.swag.live/me>; rel="user", <swag://user/birthdate>; rel="birthdate"
"""
        let result = extractor.extractLinkElements(fromString: linkStrings)
        
        XCTAssertTrue(result.count == 2)
        
        XCTAssertEqual(result.first?.value.absoluteString, "https://api.swag.live/me")
        XCTAssertEqual(result.last?.value.absoluteString, "swag://user/birthdate")
    }
    
    func testRedirectSuccess() {
        let extractor = HeaderLinkInfoExtractor()
        let linkStrings = """
Link: <https://hooks.stripe.com/redirect/authenticate/src_1CVb8gKTPfeTDdSt21Xx5C2y?client_secret=src_client_secret_CvS25cuUqYa1fABN24gd85UF>; rel="redirect"
"""
        let result = extractor.extract(fromString: linkStrings)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertEqual(result["redirect"], "https://hooks.stripe.com/redirect/authenticate/src_1CVb8gKTPfeTDdSt21Xx5C2y?client_secret=src_client_secret_CvS25cuUqYa1fABN24gd85UF")
    }
}
