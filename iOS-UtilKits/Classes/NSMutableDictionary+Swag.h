//
//  NSMutableDictionary+Swag.h
//  swag
//
//  Created by Barry on 2016/7/1.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SwagUtilKits)

- (void)setObjectIfPossible:(id)object forKey:(id <NSCopying>)key;

@end
