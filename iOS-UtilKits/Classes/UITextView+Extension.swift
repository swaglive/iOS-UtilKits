//
//  UITextView+Extension.swift
//  swagr
//
//  Created by Cold on 2019/7/27.
//  Copyright © 2019 SWAG. All rights reserved.
//

import UIKit

extension UITextView {
    public var numberOfCurrentlyDisplayedLines: Int {
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return Int(((size.height - layoutMargins.top - layoutMargins.bottom) / font!.lineHeight))
    }
    
    public func removeTextUntilSatisfying(maxNumberOfLines: Int) {
        while numberOfCurrentlyDisplayedLines > (maxNumberOfLines) {
            text = String(text.dropLast())
            layoutIfNeeded()
        }
    }
}
