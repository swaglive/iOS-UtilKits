//
//  NSMutableDictionary+Swag.m
//  swag
//
//  Created by Barry on 2016/7/1.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import "NSMutableDictionary+Swag.h"

@implementation NSMutableDictionary (Swag)

- (void)setObjectIfPossible:(id)object forKey:(id <NSCopying>)key {
    if (!object || !key) {
        return ;
    }
    [self setObject:object forKey:key];
}

@end
