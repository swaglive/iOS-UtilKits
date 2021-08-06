//
//  LinkHeader.swift
//  swag
//
//  Created by Hokila Jan on 2019/1/29.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class LinkHeader:NSObject {
    public private(set) var next:URL?
    public private(set) var last:URL?
    public private(set) var first:URL?
    public private(set) var prev:URL?
    
    public init?(response:HTTPURLResponse) {
        guard let linkStrings = response.allHeaderFields["Link"] as? String else {
            return nil
        }
        
        let result = HeaderLinkInfoExtractor().extract(fromString: linkStrings)
        guard result.count > 0 else {
            return nil
        }
        
        if let str = result["next"], let url = URL(string: str) {
            self.next = url
        }
        
        if let str = result["last"], let url = URL(string: str) {
            self.last = url
        }
        
        if let str = result["first"], let url = URL(string: str) {
            self.first = url
        }
        
        if let str = result["prev"], let url = URL(string: str) {
            self.prev = url
        }
    }
    
    
    public init(prev: URL) {
        self.prev = prev
    }
}
