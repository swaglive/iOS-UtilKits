//
//  Decodable+Extension.swift
//  swagr
//
//  Created by Finn on 2020/9/22.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

extension Decodable {
    public static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

    public static func decode(dict: Any) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: dict)
        return try decode(data: data)
    }
}
