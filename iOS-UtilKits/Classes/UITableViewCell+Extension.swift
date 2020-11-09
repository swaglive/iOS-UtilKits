//
//  UITableViewCell+Extension.swift
//  swag
//
//  Created by Hokila Jan on 2019/1/16.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension UITableViewCell {
    @objc public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
