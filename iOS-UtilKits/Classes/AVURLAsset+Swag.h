//
//  AVURLAsset+Swag.h
//  swag
//
//  Created by Barry on 2016/7/14.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVURLAsset (SwagUtilKits)

+ (UIImage *)thumbnailWithURL:(NSURL *)URL timeValue:(NSTimeInterval)timeValue;

@end
