//
//  Date+Extension.swift
//  swag
//
//  Created by Ken on 2019/1/9.
//  Copyright © 2019年 SWAG. All rights reserved.
//

import Foundation

extension DateFormatter {
    // iso 8601
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.system
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
}
