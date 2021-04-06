//
//  Data+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/4/6.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else { return nil }

        return prettyPrintedString
    }
}
