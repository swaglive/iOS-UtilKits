//
//  LimitObjectSetCache.swift
//  swag
//
//  Created by peter on 2019/1/23.
//  Copyright © SWAG. All rights reserved.
//

import Foundation

public class LimitObjectSetCache<T>: NSObject where T: Hashable {
    private var cached = Array<T>()
    private let limit: Int
    private let queue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    public init(limit: Int = 100) {
        self.limit = limit
    }
    
    public func contains(_ objcet: T) -> Bool {
        var result = false
        queue.sync {
            result = cached.contains(objcet)
        }
        return result
    }
    
    public func add(_ objcet: T) {
        guard !contains(objcet) else {
            return
        }
        append(objcet)
        if count > limit {
            removeFirst()
        }
        
    }
    private func append(_ object: T) {
        queue.async(flags:.barrier) {
            self.cached.append(object)
        }
    }
    private func removeFirst() {
        queue.async(flags:.barrier) {
            self.cached.removeFirst()
        }
    }
    public var objects: [T] {
        return cached
    }
    public var count: Int {
        var result = 0
        queue.sync {
            result = self.cached.count
        }
        return result
    }
}
