//
//  SWAppNumberFormatters.m
//  swag
//
//  Created by Mike Yu on 21/06/2017.
//  Copyright © 2017 SWAG All rights reserved.
//

#import "SWAppNumberFormatters.h"
@implementation SWAppNumberFormatters

static NSString * const kNilSymbol = @"--";

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SWAppNumberFormatters *kInstance;
    dispatch_once(&onceToken, ^{
        kInstance = [[SWAppNumberFormatters alloc] init];
    });
    return kInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _diamondNumberFormatter = [self.class createDiamondNumberFormatter];
        _signedDiamondNumberFormatter = [self.class createSignedDiamondNumberFormatter];
        _decimalNumberFormatter = [self.class createDecimalNumberFormatter];
        _revnueNumberFormatter = [self.class createRevenueNumberFormatter];
        _ungroupedDecimalNumberFormatter = [self.class createUngroupedDecimalNumberFormatter];
        _percentageFormatter = [self.class createPercentageNumberFormatter];
    }
    return self;
}

+ (NSNumberFormatter *)createUngroupedDecimalNumberFormatter {
    NSNumberFormatter *formatter = [self createDecimalNumberFormatter];
    formatter.usesGroupingSeparator = NO;
    formatter.nilSymbol = kNilSymbol;
    return formatter;
}

+ (NSNumberFormatter *)createDecimalNumberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return formatter;
}

+ (NSNumberFormatter *)createCurrencyNumberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.nilSymbol = kNilSymbol;
    return formatter;
}

+ (NSNumberFormatter *)createCurrencyFormatterWithLocale:(NSLocale *)locale {
    NSNumberFormatter *formatter = [self createCurrencyNumberFormatter];
    NSString *currencyCode = [NSString stringWithFormat:@"(%@)", locale.currencyCode];
    formatter.locale = locale;
    formatter.negativeSuffix = currencyCode;
    formatter.positiveSuffix = currencyCode;
    return formatter;
}

+ (NSNumberFormatter *)createDiamondNumberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = YES;
    formatter.maximumFractionDigits = 0;
    formatter.minimumFractionDigits = 0;
    formatter.nilSymbol = kNilSymbol;
    return formatter;
}

+ (NSNumberFormatter *)createSignedDiamondNumberFormatter {
    NSNumberFormatter *formatter = [self createDiamondNumberFormatter];
    formatter.positivePrefix = @"+";
    formatter.negativePrefix = @"-";
    return formatter;
}

+ (NSNumberFormatter *)createRevenueNumberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = YES;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    formatter.nilSymbol = @"0";
    formatter.nilSymbol = kNilSymbol;
    return formatter;
}

+ (NSNumberFormatter *)createPercentageNumberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    formatter.usesGroupingSeparator = NO;
    formatter.nilSymbol = kNilSymbol;
    return formatter;
}
@end
