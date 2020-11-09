//
//  HeaderLinkInfoExtractor.swift
//  swag
//
//  Created by peter on 2017/6/28.
//  Copyright © 2017年 SWAG. All rights reserved.
//

import Foundation

public struct LinkElement {
    public let type: String
    public let value: URL
}

@objcMembers
public class HeaderLinkInfoExtractor: NSObject {

    fileprivate static let tagRegex = try! NSRegularExpression(pattern: "rel=\"[\\S]+\"", options: [.useUnicodeWordBoundaries])    
    fileprivate static let valueRegex = try! NSRegularExpression(pattern: "<\\b(https?|file|swag)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;()]*[-a-zA-Z0-9+&@#/%=~_|]>", options: [.useUnicodeWordBoundaries])
    
    fileprivate let tagRegex: NSRegularExpression
    fileprivate let valueRegex: NSRegularExpression
    
    public override init() {
        tagRegex = HeaderLinkInfoExtractor.tagRegex.copy() as! NSRegularExpression
        valueRegex = HeaderLinkInfoExtractor.valueRegex.copy() as! NSRegularExpression
    }
    
    public func extract(fromString string: String) -> [String: String] {
        let items = string.components(separatedBy: ",")
        var result: [String: String] = [:]
        for item in items {
            if let tag = self.tag(from: item), let value = self.value(from: item) {
                result[tag] = value
            }
        }
        return result
    }
    
    public func extractLinkElements(fromString string: String) -> [LinkElement] {
        let items = string.components(separatedBy: ",")
        var result: [LinkElement] = []

        for item in items {
            let substring = item.replacingOccurrences(of: "<", with: "")
            if let idx = substring.index(of: ">") {
                let range = substring.startIndex..<idx
                
                let urlString = String(substring[range]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if let url = URL(string: urlString), let tag = self.tag(from: item) {
                    result.append(LinkElement(type: tag, value: url))
                }
            }
        }
        return result
    }

    fileprivate func tag(from text:String) -> String? {
        let wholeRange = NSRange(location: 0, length: text.lengthOfBytes(using: .utf8))
        if let match = tagRegex.matches(in: text, options: [.reportCompletion], range: wholeRange).first {
            let matchedText = (text as NSString).substring(with: match.range) as String
            let tagRange = "rel=\"".endIndex..<matchedText.index(before: matchedText.endIndex)
            return String(matchedText[tagRange])
        }
        return nil
    }
    
    fileprivate func value(from text:String) -> String? {
        let wholeRange = NSRange(location: 0, length: text.lengthOfBytes(using: .utf8))
        if let match = valueRegex.matches(in: text, options: [.reportCompletion], range: wholeRange).first {
            let matchedText = (text as NSString).substring(with: match.range) as String
            let tagRange =  matchedText.index(after: matchedText.startIndex)..<matchedText.index(before: matchedText.endIndex)
            return String(matchedText[tagRange])
        }
        return nil
    }
    
}
