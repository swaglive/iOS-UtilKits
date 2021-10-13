//
//  Encodable+Extension.swift
//  iOS-UtilKits
//
//  Created by finn on 2021/10/13.
//  Copyright © 2021 SWAG. All rights reserved.
//

import Foundation

extension Encodable {
    public var jsonString: String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.jsonString
    }
}
