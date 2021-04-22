//
//  CALayer+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/4/22.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension CALayer {
    public func setupCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        mask = maskLayer
    }
}
