//
//  RKKeyboardPresenceObserver.m
//  
//
//  Created by Mike Yu on 2016/8/23.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import "RKKeyboardPresenceObserver.h"

@interface RKKeyboardAppearanceChangeInfo ()

- (instancetype)initWithEndFrame:(CGRect)endFrame animationCurve:(UIViewAnimationOptions)animationCurve duration:(NSTimeInterval)duration;

@end

@interface RKKeyboardPresenceObserver ()

@property (assign, nonatomic) CGRect targetKeyboardRect;

@end

@implementation RKKeyboardPresenceObserver

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlerKeyboardWillChangeFrameNotificaiton:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handlerKeyboardWillChangeFrameNotificaiton:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [self notifyKeyboardWillChangeWithInfoIfNeeded:[[RKKeyboardAppearanceChangeInfo alloc] initWithEndFrame:frame animationCurve:curve duration:duration]];
}

- (void)notifyKeyboardWillChangeWithInfoIfNeeded:(RKKeyboardAppearanceChangeInfo *)info {
    if (self.keyboardWillChangeFrame) {
        self.keyboardWillChangeFrame(info);
    }
    if (self.keyboardWillChangeFrameHandler) {
        self.keyboardWillChangeFrameHandler(info.endFrame, info.animationOptions, info.duration);
    }
}

@end

@implementation RKKeyboardAppearanceChangeInfo

- (instancetype)initWithEndFrame:(CGRect)frame animationCurve:(UIViewAnimationOptions)curve duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _endFrame = frame;
        _animationOptions = curve;
        _duration = duration;
    }
    return self;
}

- (BOOL)isAppearing {
    return CGRectIntersectsRect([UIApplication sharedApplication].keyWindow.bounds, self.endFrame);
}

@end
