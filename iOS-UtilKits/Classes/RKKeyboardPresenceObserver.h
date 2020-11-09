//
//  RKKeyboardPresenceObserver.h
//  
//
//  Created by Mike Yu on 2016/8/23.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKKeyboardAppearanceChangeInfo;
@interface RKKeyboardPresenceObserver : NSObject

@property (copy, nonatomic) void(^keyboardWillChangeFrameHandler)(CGRect endFrame, UIViewAnimationOptions animationCurve, NSTimeInterval duration);
@property (copy, nonatomic) void(^keyboardWillChangeFrame)(RKKeyboardAppearanceChangeInfo *info);

@end

@interface RKKeyboardAppearanceChangeInfo : NSObject

@property (assign, nonatomic, readonly) CGRect endFrame;
@property (assign, nonatomic, readonly) BOOL isAppearing;
@property (assign, nonatomic, readonly) UIViewAnimationOptions animationOptions;
@property (assign, nonatomic, readonly) NSTimeInterval duration;

@end
