//
//  TouchRecognizer.h
//  swag
//
//  Created by Mike Yu on 01/08/2017.
//  Copyright © 2017 SWAG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FreeTouchDetector : UIGestureRecognizer

/// If you want to cancel touch action on subviews, then set `YES`. Default is `NO`.
@property (nonatomic, assign) BOOL cancelTouchOnSubview;

@end

NS_ASSUME_NONNULL_END
