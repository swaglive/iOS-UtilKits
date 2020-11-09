//
//  TaiwanTimezoneDateFormatter.swift
//  swagr
//
//  Created by peter on 2019/5/28.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class TaiwanTimezoneDateFormatter: DateFormatter {
    public class func build(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return dateFormatter
    }
}

@objcMembers
public class LocalTimezoneDateFormatter: DateFormatter {
    public class func build(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }
}
