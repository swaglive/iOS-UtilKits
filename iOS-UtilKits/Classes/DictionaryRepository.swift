//
//  DictionaryRepository.swift
//  swagr
//
//  Created by peter on 2019/12/6.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

public class DictionaryRepository {
    private let queue = DispatchQueue(label: "DictionaryRepository-\(UUID().uuidString)", attributes: .concurrent)
    private var dictionary: [String: Any] = [:]
    private var storedKeys: [String] = []
    
    public init() {}

    public func append(key: String, value: Any) {
        guard !isContains(key) else {
            return
        }
        queue.async(flags: .barrier) {
            self.dictionary[key] = value
            self.storedKeys.append(key)
        }
    }
    public func remove(key: String) {
        guard isContains(key) else {
            return
        }
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
            let filterKeys = self.storedKeys.filter( { $0 != key } )
            self.storedKeys = filterKeys
        }
    }
    public var keys: [String] {
        queue.sync { storedKeys }
    }
    public var values: [Any] {
        queue.sync { Array(dictionary.values) }
    }
    public func isContains(_ key: String) -> Bool {
        var result = false
        queue.sync {
            result = self.storedKeys.contains(key)
        }
        return result
    }
    public func removeAll() {
        storedKeys.removeAll()
        dictionary.removeAll()
    }
    public func object(_ key: String) -> Any? {
        guard isContains(key) else { return nil }
        var result: Any?
        queue.sync {
            result = dictionary[key]
        }
        return result
    }
    
    public func hasPrefix(_ prefix: String) -> [String] {
        return keys.filter { $0.hasPrefix(prefix)}
    }
}
