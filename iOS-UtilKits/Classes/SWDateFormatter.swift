//
//  SWDateFormatter.swift
//  swag
//
//  Created by Hokila Jan on 2018/12/12.
//  Copyright © 2018 SWAG. All rights reserved.
//

import Foundation

class SWAdaptiveShortStyleLeftTimeFormatter:DateFormatter {
    override func string(from date: Date) -> String {
        var leftTime = date.timeIntervalSince1970
        
        guard leftTime > 0 else {
            return ""
        }
        
        let leftHour = floor(leftTime/3600.0)
        leftTime -= leftHour*3600.0
        
        let leftMinutes = floor(leftTime/60.0)
        leftTime -= leftMinutes*60.0
        
        let leftSecond = leftTime
    
        let textHour = String(format: "%02d", Int(leftHour))
        let textMinutes = String(format: "%02d", Int(leftMinutes))
        let textSecond = String(format: "%02d", Int(leftSecond))
        
        if leftHour > 0 {
            return "\(textHour):\(textMinutes):\(textSecond)"
        } else {
            return "\(textMinutes):\(textSecond)"
        }
    }
}

extension DateFormatter {
    class func rfc1123() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return dateFormatter
    }
}
