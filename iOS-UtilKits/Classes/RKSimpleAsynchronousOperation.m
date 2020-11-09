//
//  RKSimpleAsynchronousOperation.m
//  
//
//  Created by Mike Yu on 2016/8/16.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import "RKSimpleAsynchronousOperation.h"

static NSString * const kExecutingKey = @"executing";
static NSString * const kFinishedKey = @"finished";

@interface RKSimpleAsynchronousOperation ()

@property (assign, nonatomic) BOOL privateExecuting;
@property (assign, nonatomic) BOOL privateFinished;

@end

@implementation RKSimpleAsynchronousOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _privateFinished = NO;
        _privateExecuting = NO;
    }
    return self;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.privateExecuting;
}

- (BOOL)isFinished {
    return self.privateFinished;
}

- (void)start {
    if (self.executing || self.finished || self.cancelled) {
        return;
    }
    [self willChangeValueForKey:kExecutingKey];
    self.privateExecuting = YES;
    [self didChangeValueForKey:kExecutingKey];
    [self main];
}

- (void)cancel {
    [super cancel];
    self.completionBlock = nil;
}

- (void)finish {
    if (self.cancelled) {
        return;
    }
    void (^completion)() = self.completionBlock;
    self.completionBlock = nil;
    [self willChangeValueForKey:kFinishedKey];
    [self willChangeValueForKey:kExecutingKey];
    self.privateExecuting = NO;
    self.privateFinished = YES;
    [self didChangeValueForKey:kExecutingKey];
    [self didChangeValueForKey:kFinishedKey];
    if (completion) {
        completion();
    }
}

@end
