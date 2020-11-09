//
//  UIScreen+Extension.swift
//  swagr
//
//  Created by peter on 2020/9/23.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

extension UIScreen {
    public var screenShot: UIImage? {
        let screenshotSize = UIScreen.main.bounds.size
        let renderer = UIGraphicsImageRenderer(size: screenshotSize)
        let screenshot = renderer.image { _ in
            UIApplication.shared.keyWindow?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        }
        return screenshot
    }
}
