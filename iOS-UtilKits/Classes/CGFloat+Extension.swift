//
//  CGFloat+Extension.swift
//  swag
//
//  Created by peter on 2017/6/20.
//  Copyright © 2017年 SWAG. All rights reserved.
//

import Foundation

extension CGFloat {
    public var ceil: CGFloat {
        return CGFloat(ceilf(Float(self)))
    }
    public var floor: CGFloat {
        return CGFloat(floorf(Float(self)))
    }
}

