//
//  TouchRecognizer.m
//  swag
//
//  Created by Mike Yu on 01/08/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

#import "FreeTouchDetector.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FreeTouchDetector

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.cancelsTouchesInView = NO;
        self.delaysTouchesBegan = NO;
        self.delaysTouchesEnded = NO;
        _cancelTouchOnSubview = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self isTouchingOnActiveControl:touches withEvent:event]) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    self.state = UIGestureRecognizerStateBegan;
}

- (BOOL)isTouchingOnActiveControl:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *view = [self.view hitTest:[touches.anyObject locationInView:self.view] withEvent:event];
    if (self.cancelTouchOnSubview && self.view != view) {
        return YES;
    }
    while (view && self.view != view) {
        if ([self isActiveControl:view]) {
            return YES;
        }
        view = view.superview;
    }
    return NO;
}

- (BOOL)isActiveControl:(UIView *)view {
    if (![view isKindOfClass:UIControl.class]) {
        return NO;
    }
    UIControl *control = (UIControl *)view;
    return control.userInteractionEnabled && control.enabled && !control.hidden && (control.alpha > 0.0f);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

@end
