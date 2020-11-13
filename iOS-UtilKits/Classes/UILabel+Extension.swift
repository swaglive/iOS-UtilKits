//
//  UILabel+Extension.swift
//  schat
//
//  Created by peter on 2019/12/25.
//  Copyright © 2019 SWAG. All rights reserved.
//

import UIKit

extension UILabel {
    public func hightlight(_ hightlightedString: String, normalAttributes: [NSAttributedString.Key : Any], highlightedAttributes: [NSAttributedString.Key : Any]) {
        guard let caption = self.text, caption.contains(hightlightedString) else { return }
                
        let highlightedRange = (caption as NSString).range(of: hightlightedString)
        let attributedString = AttributedStringBuilder(attributeds: normalAttributes).string(caption)
        attributedString.addAttributes(highlightedAttributes, range: highlightedRange)
        self.attributedText = attributedString
    }

}
