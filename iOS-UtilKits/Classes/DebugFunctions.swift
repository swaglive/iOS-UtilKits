//
//  DebugFunctions.swift
//  swag
//
//  Created by Mike Yu on 19/10/2017.
//  Copyright © SWAG. All rights reserved.
//

import Foundation

public func memoryAddress<T: AnyObject>(of x: T) -> Int {
    return unsafeBitCast(x, to: Int.self)
}

public func instanceInfoHeader(of x: Any) -> String {
    if let obj = x as? AnyObject {
        return "<\(type(of: x)): \(memoryAddress(of: obj))>"
    }
    return "<\(type(of: x))>"
}
