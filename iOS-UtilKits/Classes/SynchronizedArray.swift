//
//  SynchronizedArray.swift
//  swagr
//
//  Created by peter on 2019/12/27.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

public class SynchronizedArray<T: Hashable> {
    private var arraySet = Set<T>()
    private let accessQueue = DispatchQueue(label: "SynchronizedArray-\(UUID().uuidString)", attributes: .concurrent)

    public init() {}

    public func append(_ newElement: T) {
        self.accessQueue.async(flags:.barrier) {
            self.arraySet.insert(newElement)
        }
    }
    public func append(_ newElements: [T]) {
        newElements.forEach {[weak self] (T) in
            self?.append(T)
        }
    }

    public func removeAtIndex(element: T) {
        self.accessQueue.async(flags:.barrier) {
            self.arraySet.remove(element)
        }
    }
    
    public func removeAll() {
        self.accessQueue.async(flags:.barrier) {
            self.arraySet.removeAll()
        }
    }

    public func contains(member: T) -> Bool {
        var retVal: Bool = false
        accessQueue.sync {
            retVal = arraySet.contains(member)
        }
        return retVal
    }
    
    public func remove(memeber: T) {
        self.accessQueue.async(flags:.barrier) {
            self.arraySet.remove(memeber)
        }
    }
    
    public var count: Int {
        var count = 0
        self.accessQueue.sync {
            count = self.array.count
        }
        return count
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var array: [T] {
        var retVal: [T] = []
        accessQueue.sync {
            retVal = Array(arraySet)
        }
        return retVal
    }

}

extension SynchronizedArray {
    public func moveFirst(_ maxLength: Int) -> [T] {
        var objectList = array
        
        let min = Swift.min(maxLength, objectList.count)
             
        let slice = objectList.prefix(min)
        let result = Array(slice)
        objectList.removeFirst(min)
        self.accessQueue.async(flags:.barrier) {
            self.arraySet = Set(objectList)
        }
        return result
    }
    
}
