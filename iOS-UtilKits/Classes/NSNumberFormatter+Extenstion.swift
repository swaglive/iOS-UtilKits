//
//  NSNumberFormatter+Extenstion.swift
//  swag
//
//  Created by peter on 2017/7/18.
//  Copyright © 2017年 SWAG. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public func stringValue(for value: Any?) -> String {
        guard let value = value else {
            return self.nilSymbol
        }
        return self.string(for: value) ?? self.nilSymbol
    }
}
