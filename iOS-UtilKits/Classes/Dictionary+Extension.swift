//
//  Dictionary+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/4/14.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension Dictionary {
    public var jsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []),
              let json = data.jsonString else { return nil }
        return json
    }
}
