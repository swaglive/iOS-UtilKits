//
//  ImageSet.swift
//  swag
//
//  Created by Ken on 2018/12/4.
//  Copyright © SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class ImageSet: NSObject {
    
    let pathBuilder: (Int, Int) -> URL
    
    public init(builder: @escaping (_ width: Int, _ height: Int) -> URL) {
        self.pathBuilder = builder
        super.init()
    }
        
    lazy public var thumbnail: URL = pathBuilder(ImageSize.thumbnail.width, ImageSize.thumbnail.height)
    
    lazy public var small: URL = pathBuilder(ImageSize.small.width, ImageSize.small.height)

    lazy public var medium: URL =  pathBuilder(ImageSize.medium.width, ImageSize.medium.height)
    
    lazy public var large: URL = pathBuilder(ImageSize.large.width, ImageSize.large.height)
    
    lazy public var extraLarge: URL = pathBuilder(ImageSize.extraLarge.width, ImageSize.extraLarge.height)

    lazy public var fullscreen: URL = pathBuilder(ImageSize.fullscreen.width, ImageSize.fullscreen.height)
    
    lazy public var all: [URL] = [thumbnail, small, medium, large, fullscreen]
}


public struct ImageSize {
    //2^n, 11 => 2^11 = 2048
    static private let maximumSupportPowerOfTwo: Int = 11
    static private var maximumSupportSizeWidth: Int {
        return NSDecimalNumber(decimal: pow(2, maximumSupportPowerOfTwo)).intValue
    }
    
    static private var coerceInPowerOfTwo: Int {
        let screenMaxWidth = max(Int(UIScreen.main.bounds.size.width),
                                 Int(UIScreen.main.bounds.size.height)) * Int(UIScreen.main.scale)
        let coerceInPowerOfTwo = (5...maximumSupportPowerOfTwo)
            .map({ NSDecimalNumber(decimal: pow(2, $0)).intValue })
            .filter({ Int($0) >= screenMaxWidth })
            .first ?? maximumSupportSizeWidth
        return min(coerceInPowerOfTwo, maximumSupportSizeWidth)
    }
    
    public let width, height: Int
    
    static public let thumbnail = ImageSize(width: 64, height: 64)
    
    static public let small = ImageSize(width: 128, height: 128)
    
    static public let medium = ImageSize(width: 256, height: 256)
    
    static public let large = ImageSize(width: 512, height: 512)
    
    static public let extraLarge = ImageSize(width: 1024, height: 1024)

    static public let fullscreen = ImageSize(width: coerceInPowerOfTwo, height: coerceInPowerOfTwo)
}
