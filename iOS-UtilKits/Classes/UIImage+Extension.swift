//
//  UIImage+Extension.swift
//  schat
//
//  Created by Drain on 2019/12/18.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension UIImage {
    public func roundedImageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.cornerRadius = square.width / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        var result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        result = result?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return result
    }

    public static func resizableRoundedRect(withSize size: CGSize,
                              cornerRadius: CGFloat? = nil,
                              fillColor: UIColor,
                              border: (width: CGFloat, color: UIColor)? = nil) -> UIImage {
        roundedRect(withSize: size, cornerRadius: cornerRadius, fillColor: fillColor, border: border)
                .resizableImage(
                        withCapInsets: UIEdgeInsets(top: size.height / 2, left: size.width / 2, bottom: size.height / 2, right: size.width / 2),
                        resizingMode: .stretch
                )
    }
    
    //just for objc
    @objc public static func roundedRect(withSize size: CGSize,
                                  cornerRadius: CGFloat,
                                  fillColor: UIColor,
                                  borderWidth: CGFloat,
                                  borderColor: UIColor?) -> UIImage {
        let border: (width: CGFloat, color: UIColor)?
        if let borderColor = borderColor {
            border = (borderWidth, borderColor)
        } else {
            border = nil
        }
        return roundedRect(withSize: size, cornerRadius: cornerRadius, fillColor: fillColor, border: border)
    }
    
    public static func roundedRect(withSize size: CGSize,
                     cornerRadius: CGFloat? = nil,
                     fillColor: UIColor,
                     border: (width: CGFloat, color: UIColor)? = nil) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            let borderWidth = border?.width ?? 0
            let context = rendererContext.cgContext
            let path = UIBezierPath(
                roundedRect: CGRect(x: borderWidth / 2, y: borderWidth / 2, width: size.width - borderWidth, height: size.height - borderWidth),
                cornerRadius: cornerRadius ?? ((size.width - borderWidth) / 2)
            )
            if let borderColor = border?.color {
                context.setLineWidth(borderWidth)
                context.setStrokeColor(borderColor.cgColor)
                path.stroke()
            }
            context.setFillColor(fillColor.cgColor)
            path.fill()
        }
    }

    public func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    public static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
