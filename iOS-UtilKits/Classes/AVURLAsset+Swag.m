//
//  AVURLAsset+Swag.m
//  swag
//
//  Created by Barry on 2016/7/14.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import "AVURLAsset+Swag.h"
#import <UIKit/UIImage.h>

@implementation AVURLAsset (Swag)

+ (UIImage *)thumbnailWithURL:(NSURL *)URL timeValue:(NSTimeInterval)timeValue {
    AVAsset *asset = [AVAsset assetWithURL:URL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = timeValue;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbnail;
}

@end
