//
//  NSDateFormatter+Swag.m
//  swag
//
//  Created by Barry on 2017/6/27.
//  Copyright © 2017年 SWAG. All rights reserved.
//

#import "NSDateFormatter+Swag.h"

@implementation NSDateFormatter (Swag)

+ (NSDateFormatter *)SWHourMinuteFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    return formatter;
}

+ (NSDateFormatter *)SWMonthDayFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM/dd";
    return formatter;
}

+ (NSDateFormatter *)SWYearMonthFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY/MM";
    return formatter;
}

+ (NSDateFormatter *)SWFullTimeFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm";
    return formatter;
}

@end
