//
// Created by drain on 2020/2/18.
// Copyright (c) 2020 SWAG. All rights reserved.
//

import Foundation

extension Encodable {
    public func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
    
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}
