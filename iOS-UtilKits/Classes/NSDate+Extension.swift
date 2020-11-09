//
//  NSDate+Extension.swift
//  swag
//
//  Created by peter on 2017/7/10.
//  Copyright © 2017年 SWAG. All rights reserved.
//

import Foundation

extension Date {
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    public var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    public func ago(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)!
    }
    public func yearsAgo(_ years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: -years, to: self)!
    }
    public var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    public var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    public var nextDay: Date {
        return  Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    public var previousDay: Date {
        return  Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    public var startOfNextDay: Date {
        return self.nextDay.startOfDay
    }
    
    public var startOfPreviousDay: Date {
        return self.previousDay.startOfDay
    }
    
}

public class TimezoneCalendar {
    public static let shared = TimezoneCalendar()
    
    private static var taiwanCalendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
    
    public let taiwan = TimezoneDateHelper(calendar: taiwanCalendar)
}

public class TimezoneDateHelper {
    public let calendar: Calendar
    private let localFormatter = LocalTimezoneDateFormatter.build(format: "YYYY/MM/dd HH:mm")
    private let formatter = TaiwanTimezoneDateFormatter.build(format: "YYYY/MM/dd HH:mm")
    
    public init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    public func startOfDay(_ date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }
    
    public func endOfDay(_ date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfDay(date))!
    }
    
    public func nextDay(_ date: Date) ->  Date {
        return  calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    public func startOfNextDay(_ date: Date) ->  Date {
        let nextDay = self.nextDay(date)
        return startOfDay(nextDay)
    }
    public func ago(_ days: Int, from date: Date) -> Date {
        return calendar.date(byAdding: .day, value: -days, to: date)!
    }
    public func date(_ date: Date) -> Date {
        let localDateString = localFormatter.string(from: date)
        return formatter.date(from: localDateString) ?? Date()
    }
    
    public var date: Date {
        return formatter.date(from: formatter.string(from: Date()))!
    }
}
