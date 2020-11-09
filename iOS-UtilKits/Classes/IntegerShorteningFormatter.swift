//
//  IntegerShorteningFormatter.swift
//  swag
//
//  Created by Mike Yu on 2018/7/3.
//  Copyright © 2018 SWAG. All rights reserved.
//

import UIKit

class IntegerShorteningFormatter: Formatter {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    override func string(for obj: Any?) -> String? {
        if let int = obj as? Int64 {
            return string(for: int)
        }
        return nil
    }
    
    func string(for int: Int) -> String {
        return string(for: Int64(int))
    }

    private func string(for int: Int64) -> String {
        var mantissa: Double = Double(int)
        var symbol = ""
        if int / .billion > 0 {
            mantissa = Double(int) / Double(Int64.billion)
            symbol = "b"
        } else if int / .million > 0 {
            mantissa = Double(int) / Double(Int64.million)
            symbol = "m"
        } else if int / .thousand > 0 {
            mantissa = Double(int) / Double(Int64.thousand)
            symbol = "k"
        }
        return (formatter.string(from: NSNumber(value: mantissa)) ?? "") + symbol
    }
}


extension Int64 {
    static let thousand: Int64 = 1000
    static let million = 1000 * thousand
    static let billion = 1000 * million
}
