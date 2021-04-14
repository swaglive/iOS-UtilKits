//
//  Data+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/4/6.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension Data {
    public var jsonString: String? {
        return String(data: self, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    }
}
