//
//  AttributedStringBuilder.swift
//  schat
//
//  Created by peter on 2019/5/8.
//  Copyright © SWAG. All rights reserved.
//

import Foundation

public class AttributedStringBuilder {
    public private(set) var attributeds: [NSAttributedString.Key: Any] = [:]

    public init() {
    }
    
    @discardableResult public func font(_ font: UIFont) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.font] = font
        return self
    }

    @discardableResult public func systemFont(ofSize size: CGFloat) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: size)
        return self
    }
    
    @discardableResult public func foregroundColor(_ color: UIColor) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.foregroundColor] = color
        return self
    }
    
    @discardableResult public func underlineStyle(_ style: NSUnderlineStyle) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.underlineStyle] = style.rawValue
        return self
    }
    
    @discardableResult public func link(_ url: URL) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.link] = url
        return self
    }
    
    @discardableResult public func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> AttributedStringBuilder {
        attributeds[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return self
    }
    
    @discardableResult public func string(_ string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: attributeds)
    }
    
    @discardableResult public func attributedString(_ attributedString: NSAttributedString) -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: attributedString)
    }
    
    @discardableResult public func alignment(_ alignment: NSTextAlignment) -> AttributedStringBuilder {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        attributeds[NSAttributedString.Key.paragraphStyle] = style
        return self
    }
}


