//
//  SWMulticastCallbackManager.m
//  swag
//
//  Created by Mike Yu on 05/07/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

#import "SWMulticastCallbackManager.h"

@interface SWMulticastCallbackManager<HandlerType> ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, HandlerType> *managedHandlers;

@end

@implementation SWMulticastCallbackManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _managedHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)generateKey {
    return [NSUUID UUID].UUIDString;
}

- (id)addHandler:(id)handler {
    NSString *key = [self generateKey];
    self.managedHandlers[key] = [handler copy];
    return key;
}

- (void)removeCallback:(id)callBack {
    NSParameterAssert(callBack);
    [self.managedHandlers removeObjectForKey:callBack];
}

- (void)invokeEachHandler:(void (^)(id))invocation {
    NSParameterAssert(invocation);
    for (id handler in self.managedHandlers.allValues) {
        invocation(handler);
    }
}

- (NSString *)debugDescription {
    NSString *result = [super debugDescription];
    result = [result stringByAppendingFormat:@"{ count: %@, handlers: %@ }", @(self.managedHandlers.count), self.managedHandlers];
    return result;
}

@end
