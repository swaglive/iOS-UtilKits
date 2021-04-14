//
//  Dictionary+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/4/14.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension Dictionary {
    public var prettyPrintedJSONString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return jsonData.prettyPrintedJSONString
    }
}
