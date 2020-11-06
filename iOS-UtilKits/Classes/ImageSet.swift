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
    
    lazy public var fullscreen: URL = pathBuilder(ImageSize.fullscreen.scaledWidth, ImageSize.fullscreen.scaledHeight)
    
    lazy public var all: [URL] = [thumbnail, small, medium, large, fullscreen]
}


public struct ImageSize {
    
    public let width, height: Int
    
    public var scaledWidth: Int { return width * Int(UIScreen.main.scale) }
    public var scaledHeight: Int { return height * Int(UIScreen.main.scale) }
    
    static public let thumbnail = ImageSize(width: 64, height: 64)
    
    static public let small = ImageSize(width: 128, height: 128)
    
    static public let medium = ImageSize(width: 256, height: 256)
    
    static public let large = ImageSize(width: 1024, height: 1024)
    
    static public let fullscreen = ImageSize(width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height))
}
