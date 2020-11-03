//
//  DisposeBag.swift
//  swagr
//
//  Created by David Tai on 2019/4/11.
//  Copyright © 2019 SWAG. All rights reserved.
//

import UIKit

@objcMembers
public class DisposeBag: NSObject {
    private var elements: [Any] = []
    public var disposeHandler: ((Any) -> ())?
    
    public func append(_ element: Any) {
        elements.append(element)
    }
    
    deinit {
        for element in elements {
            disposeHandler?(element)
        }
    }
}
