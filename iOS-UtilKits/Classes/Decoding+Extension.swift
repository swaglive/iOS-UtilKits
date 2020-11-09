//
//  Decoding+Extension.swift
//  swag
//
//  Created by Ken on 2019/1/9.
//  Copyright © 2019年 SWAG. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    public func decodeDateIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date? {
        guard self.contains(key) else { return nil }
        if let v = try? self.decode(Int.self, forKey: key) {
            return Date(timeIntervalSince1970: TimeInterval(v))
        } else if let v = try? self.decode(String.self, forKey: key) {
            return DateFormatter.iso8601.date(from: v)
        }
        return nil
    }
}
