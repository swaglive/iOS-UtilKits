//
//  SWMulticastCallbackManager.h
//  swag
//
//  Created by Mike Yu on 05/07/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMulticastCallbackManager<HandlerType> : NSObject

- (id)addHandler:(HandlerType)handler;
- (void)removeCallback:(id)callBack;
- (void)invokeEachHandler:(void(^)(HandlerType handler))invocation;

@end
