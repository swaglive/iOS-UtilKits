//
//  AttributedStringBuilderTest.swift
//  schatTests
//
//  Created by peter on 2019/5/9.
//  Copyright © 2019 SWAG. All rights reserved.
//

import XCTest
import iOS_UtilKits

class AttributedStringBuilderTest: XCTestCase {

    func testFont() {
        var attributeds = AttributedStringBuilder().systemFont(ofSize: 12).attributeds
        
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! UIFont, UIFont.systemFont(ofSize: 12))
        

        attributeds = AttributedStringBuilder().font(UIFont.systemFont(ofSize: 14)).attributeds
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! UIFont, UIFont.systemFont(ofSize: 14))
    }
    
    func testForegroundColor() {
        let attributeds = AttributedStringBuilder().foregroundColor(UIColor.white).attributeds
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! UIColor, UIColor.white)
    }

    func testUnderlineStyle() {
        let attributeds = AttributedStringBuilder().underlineStyle(.single).attributeds
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! Int, NSUnderlineStyle.single.rawValue)
    }
    
    func testLink() {
        let attributeds = AttributedStringBuilder().link(URL(string: "https://swag.live")!).attributeds
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! URL, URL(string: "https://swag.live")!)
    }
    
    func testParagraphStyle() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributeds = AttributedStringBuilder().paragraphStyle(paragraphStyle).attributeds
        XCTAssertEqual(attributeds.count, 1)
        XCTAssertEqual(attributeds.first?.value as! NSMutableParagraphStyle, paragraphStyle)
    }

    func testMultiConfig() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributeds = AttributedStringBuilder().foregroundColor(UIColor.white).underlineStyle(.single).systemFont(ofSize: 12).paragraphStyle(paragraphStyle).attributeds
        XCTAssertEqual(attributeds.count, 4)
        XCTAssertNotNil(attributeds[NSAttributedString.Key.font])
        XCTAssertNotNil(attributeds[NSAttributedString.Key.underlineStyle])
        XCTAssertNotNil(attributeds[NSAttributedString.Key.foregroundColor])
        XCTAssertNotNil(attributeds[NSAttributedString.Key.paragraphStyle])
    }
    
}
