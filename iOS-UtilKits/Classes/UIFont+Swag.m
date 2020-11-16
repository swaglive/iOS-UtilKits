//
//  UIFont+Swag.m
//  swag
//
//  Created by Boy Lee on 6/26/16.
//  Copyright © 2016 SWAG. All rights reserved.
//

#import "UIFont+Swag.h"

@implementation UIFont (SwagUtilKits)

#pragma deploymate push "ignored-api-availability"

+ (instancetype)lightSystemFontOfSize:(CGFloat)fontSize {
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
    } else {
        return [UIFont fontWithName:@"PingFangTC-Light" size:fontSize];
    }
}

+ (instancetype)regularSystemFontOfSize:(CGFloat)fontSize {
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
    } else {
        return [UIFont fontWithName:@"PingFangTC-Regular" size:fontSize];
    }
}

+ (instancetype)mediumSystemFontOfSize:(CGFloat)fontSize {
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
    } else {
        return [UIFont fontWithName:@"PingFangTC-Medium" size:fontSize];
    }
}

+ (instancetype)semiBoldSystemFontOfSize:(CGFloat)fontSize {
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
    } else {
        return [UIFont fontWithName:@"PingFangTC-Semibold" size:fontSize];
    }
}

#pragma deploymate pop

@end
