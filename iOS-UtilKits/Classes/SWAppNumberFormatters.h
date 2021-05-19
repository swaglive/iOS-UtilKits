//
//  SWAppNumberFormatters.h
//  swag
//
//  Created by Mike Yu on 21/06/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SWAppNumberFormatters : NSObject

+ (instancetype)sharedInstance;
+ (NSNumberFormatter *)createBackgroundColorFormatterWithLocale:(NSLocale *)locale;

/**
 Original 99999 -> 99999
 */
@property (strong, nonatomic, readonly) NSNumberFormatter *ungroupedDecimalNumberFormatter;

/**
 99999999999 -> 99,999,999,999
 */

@property (strong, nonatomic, readonly) NSNumberFormatter *decimalNumberFormatter;

/**
 1 -> 100%, 0.95 -> 95%
 */
@property (strong, nonatomic, readonly) NSNumberFormatter *percentageFormatter;

/**
 99999999999 -> 99,999,999,999
 */
@property (strong, nonatomic, readonly) NSNumberFormatter *memberNumberFormatter;

/**
 99999999999 -> 99,999,999,999
 */
@property (strong, nonatomic, readonly) NSNumberFormatter *readCountNumberFormatter;

/**
 99999 -> +99,999
 */
@property (strong, nonatomic, readonly) NSNumberFormatter *signedMemberNumberFormatter;
@end
NS_ASSUME_NONNULL_END
