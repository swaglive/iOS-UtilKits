//
//  String+Swag.swift
//  swag
//
//  Created by Hokila Jan on 2018/6/14.
//  Copyright © 2018年 SWAG. All rights reserved.
//

import Foundation

extension Character {
    public var isHalfwidth: Bool {
        guard isASCII, let asciiValue = asciiValue else { return false }
        return 32..<127 ~= asciiValue
    }
}

extension String {
    
    /// Convert to NSString.
    public func objc() -> NSString {
        self as NSString
    }
    
    public func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }

    public var countWithHalfwidth: Float {
        var count: Float = 0
        self.forEach { (char) in
            count += char.isHalfwidth ? 0.5 : 1
        }
        return count
    }
    
    public func trimWithHalfwidth(_ maxLength: Int) -> String {
        var count: Float = 0

        let result: [Character] = self.compactMap({
            count += $0.isHalfwidth ? 0.5 : 1
            return count <= Float(maxLength) ? $0 : nil
        })
        return String(result)
    }
}

extension StringProtocol {
    public func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    public func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    public func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    public func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

