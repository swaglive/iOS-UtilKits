//
//  URLComponents+Extension.swift
//  schat
//
//  Created by peter on 2019/4/22.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension URLComponents {
    public func valueOf(key: String) -> String? {
        return self.queryItems?.filter { $0.name == key }.first?.value
    }
    public func keyHas(prefix: String) -> String? {
        return self.queryItems?.filter { $0.name.hasPrefix(prefix) }.first?.name
    }

    public var queryItemDictionary: [String: String] {
        var results = [String: String]()
        if let items = queryItems {
            items.forEach{results[$0.name] = $0.value}
        }
        
        return results
    }
}
