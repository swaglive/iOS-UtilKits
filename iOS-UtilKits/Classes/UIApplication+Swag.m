//
//  UIApplication+Swag.m
//  swag
//
//  Created by Barry on 2016/12/27.
//  Copyright © 2016年 SWAG. All rights reserved.
//

#import "UIApplication+Swag.h"
#import <mach-o/dyld.h>

@implementation UIApplication (SwagUtilKits)

- (BOOL)jailbreakTweakExists:(NSString *)tweakName {
    if (tweakName.length == 0) {
        return NO;
    }
    uint32_t imageCount = _dyld_image_count();
    
    for (uint32_t count = 0; count < imageCount; count++) {
        const char *imageName = _dyld_get_image_name(count);
        
        NSString *name = [[NSString alloc] initWithUTF8String:imageName];
        if ([name containsString:@"/Library/MobileSubstrate"]) {
            if ([name containsString:tweakName]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)UniversalVideoDownloaderExists {
    return [self jailbreakTweakExists:@"UVD.dylib"] || [self jailbreakTweakExists:@"UniversalVideoDownloader.dylib"];
}

@end
