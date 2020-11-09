//
//  TimeInterval+Extension.swift
//  swagr
//
//  Created by Kory on 2019/9/16.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension TimeInterval {
    public func convertToMinuteSeconds() -> String? {
        guard self > 0 else { return nil }
        let second = Int(self) % 60
        let minutes = Int(self) / 60
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", second))"
    }
    
    public func duration(from time: TimeInterval?) -> String {
        guard let laterTime = time else { return "00:00:00" }
        var leftDuration = Int(laterTime - self)
        
        let hour = leftDuration / 3600
        leftDuration = leftDuration % 3600
        
        let minutes = leftDuration / 60
        leftDuration = leftDuration % 60
        
        let second = leftDuration
        
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minutes)):\(String(format: "%02d", second))"
    }
}
