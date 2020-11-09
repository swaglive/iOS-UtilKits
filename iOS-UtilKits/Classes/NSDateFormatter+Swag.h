//
//  NSDateFormatter+Swag.h
//  swag
//
//  Created by Barry on 2017/6/27.
//  Copyright © 2017年 SWAG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (Swag)

+ (NSDateFormatter *)SWHourMinuteFormatter;
+ (NSDateFormatter *)SWMonthDayFormatter;
+ (NSDateFormatter *)SWYearMonthFormatter;
+ (NSDateFormatter *)SWFullTimeFormatter;
@end

NS_ASSUME_NONNULL_END
