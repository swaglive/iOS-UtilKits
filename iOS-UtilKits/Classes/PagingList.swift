//
//  PagingList.swift
//  swag
//
//  Created by Ken on 2019/1/9.
//  Copyright © 2019年 SWAG. All rights reserved.
//

import Foundation

public protocol Identifiable {
    var identifier: String { get }
}

open class PagingList<T:Identifiable> {
    
    /**
     travers direction, look unit test for more detail
    */
    public let traversing: Traversing
    
    /**
     indicate current page list is loading or not.
     */
    public var isLoading: Bool { return loadingTask != nil }
    
    /**
     linkHeader is store the last API response, used to understand the next page API path
     related to hasMore property
    */
    public private(set) var linkHeader: LinkHeader?
    
    /**
     accessQueue to keep thread safe
    */
    private let accessQueue = DispatchQueue(label: "concurrent.queue.PagingList", attributes: .concurrent)
    
    /**
     items store the element fetch from web service,
     direct access is not thread safe, use property provide in PagingList
     */
    private var internalItems: [T] = []
    public var items: [T] {
        var returnItem: [T] = [T]()
        
        self.accessQueue.sync {
            if !self.internalItems.isEmpty {
                returnItem = internalItems
            }
        }
        
        return returnItem
    }
    
    /**
     itemLocating is used to fast locate elemnt
     only expose for unit test, access from subscript
    */
    private var itemLocating: [String: Locating] = [:]
    
    private var loadingTask: URLSessionDataTask?
    
    /**
     callback when fetch item success, trigger every page
     */
    public var itemsDidUpdate: ((_ isReload: Bool) -> Void)?
    
    /**
     callback when fetch item fail, trigger every page
     */
    public var itemsDidFailToUpdate: ((Error?) -> Void)?
    
    public init(items: [T]? = nil, traversing: Traversing = .next, completion:(()->())? = nil) {
        self.traversing = traversing
        if let items = items {
            append(items: items, completion: completion)
        }
    }
    
    open func loadData(with linkHeader: LinkHeader?, success: (([T], LinkHeader?) -> Void)?, failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        assertionFailure("Should implementation in subclass")
        return nil
    }
}

extension PagingList {
    
    public func append(items: [T], completion:(()->())? = nil) {
        self.accessQueue.async(flags:.barrier) {
            let newItems = items.filter { self.itemLocating[$0.identifier] == nil }
            // locating
            if self.traversing == .next {
                for (i, t) in newItems.enumerated() {
                    let previous = i > 0 ? newItems[i - 1] : nil
                    let next = i < newItems.count - 1 ? newItems[i + 1] : nil
                    self.locate(item: t, previous: previous, next: next)
                }
            } else {
                for (i, t) in newItems.enumerated().reversed() {
                    let previous = i > 0 ? newItems[i - 1] : nil
                    let next = i < newItems.count - 1 ? newItems[i + 1] : nil
                    self.locate(item: t, previous: previous, next: next)
                }
            }
            // locate boundary items
            switch self.traversing {
            case .next:
                if let t = self.internalItems.last {
                    self.itemLocating[t.identifier]?.next = newItems.first
                }
                if let t = newItems.first {
                    self.itemLocating[t.identifier]?.previous = self.internalItems.last
                }
                self.internalItems += newItems
            case .previous:
                if let t = self.internalItems.first {
                    self.itemLocating[t.identifier]?.previous = newItems.last
                }
                if let t = newItems.last {
                    self.itemLocating[t.identifier]?.next = self.internalItems.first
                }
                self.internalItems = newItems + self.internalItems
            }
        
            DispatchQueue.main.async{
                completion?()
            }
        }
    }
    
    private func locate(item t: T, previous: T?, next: T?) {
        var l = Locating(item: t)
        l.previous = previous
        l.next = next
        itemLocating[t.identifier] = l
    }
}

// MARK: - Manage List

extension PagingList {
    
    public func reloadItems() {
        linkHeader = nil
        loadingTask?.cancel()
        loadingTask = nil
        
        clearItems()
        
        loadNextPage()
    }
    
    public func loadNextPage() {
        guard hasMore != false, loadingTask == nil else {
            itemsDidFailToUpdate?(nil)
            return
        }
        
        let isReload = linkHeader == nil
        
        loadingTask = loadData(with: linkHeader, success: { [weak self] (items, header) in
            self?.didLoad(items: items, header: header,completion: {
                self?.loadingTask = nil
                DispatchQueue.main.async {
                    self?.itemsDidUpdate?(isReload)
                }
            })
        }, failure: { [weak self] error in
            self?.loadingTask = nil

            DispatchQueue.main.async {
                self?.itemsDidFailToUpdate?(error)
            }
        })
    }
    
    private func didLoad(items: [T], header: LinkHeader?, completion:(()->())?) {
        linkHeader = removeLinkHeaderIsNeeded(items) == true ? nil : header
        append(items: items, completion: completion)
    }
    
    //If all items are duplicate, stop load more
    private func removeLinkHeaderIsNeeded(_ items:[T]) -> Bool {
        guard items.count > 0, self.internalItems.count > 0, self.internalItems.count != items.count else {
            return false //ignore first page
        }
        
        //the new item not duplicated from original items
        let newItems = items.filter { self.itemLocating[$0.identifier] == nil }
        return newItems.isEmpty
    }
    
    private func clearItems() {
        itemLocating.removeAll()
        internalItems.removeAll()
    }
    
    public var hasMore: Bool? {
        guard let header = linkHeader else {
            if self.internalItems.count > 0 {
                return false
            } else {
                return nil
            }
        }
        
        switch traversing {
        case .next:
            return header.next != nil
        case .previous:
            return header.prev != nil
        }
    }
}

// MARK: Manage Item

extension PagingList {
    
    public func update(item: T, completion:(()->())? = nil) {
        self.accessQueue.async(flags:.barrier) {
            guard self.itemLocating[item.identifier] != nil
                else { return }
            // remove old locating
            self.itemLocating[item.identifier] = nil
            // replace and relocate item
            for (i, t) in self.internalItems.enumerated() {
                guard t.identifier == item.identifier
                    else { continue }
                self.internalItems[i] = item
                self.locate(item: item, previous: i > 0 ? self.internalItems[i - 1] : nil, next: i < self.internalItems.count - 1 ? self.internalItems[i + 1] : nil)
                if i > 0 {
                    self.itemLocating[self.internalItems[i - 1].identifier]?.next = item
                }
                if i < self.internalItems.count - 1 {
                    self.itemLocating[self.internalItems[i + 1].identifier]?.previous = item
                }
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    // TODO: insert single item
    
    public func delete(at index:Int, completion:(()->())? = nil) {
        self.accessQueue.sync {
            guard self.internalItems.isEmpty == false, index <= self.internalItems.count - 1 else {
                debugPrint("delete index out of bound")
                return
            }
            
            self.delete(item: self.internalItems[index], completion:completion)
        }
    }
    
    public func delete(item: T, completion:(()->())? = nil) {
        self.accessQueue.sync {
            guard let locating = self.itemLocating[item.identifier],
                let index = self.internalItems.firstIndex(where:{ $0.identifier == item.identifier }) else {
                    return
            }
            
            // update nearby item locating
            if index > 0 {
                self.itemLocating[self.internalItems[index - 1].identifier]?.next = locating.next
            }
            
            if index < self.internalItems.count - 1 {
                self.itemLocating[self.internalItems[index + 1].identifier]?.previous = locating.previous
            }
            
            // remove locating
            self.itemLocating[item.identifier] = nil
            self.internalItems.remove(at: index)
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    /* delete items from index, including the index item */
    public func deleteAll(from index:Int, completion:(()->())? = nil) {
        self.accessQueue.sync {
            guard self.internalItems.isEmpty == false, index <= self.internalItems.count - 1 else {
                debugPrint("delete index out of bound")
                return
            }
            
            // update item locating
            if index > 0 {
                self.itemLocating[self.internalItems[index - 1].identifier]?.next = nil
            }
            
            for i in index...self.internalItems.count - 1 {
                self.itemLocating[self.internalItems[i].identifier] = nil
            }
            
            self.internalItems.removeLast(self.internalItems.count - index)
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}

// MARK: Query

extension PagingList {
    
    public func item(after item: T) -> T? {
        var result:T?
        self.accessQueue.sync {
            result = itemLocating[item.identifier]?.next
        }
        return result
    }
    
    public func item(before item: T) -> T? {
        var result:T?
        self.accessQueue.sync {
            result = itemLocating[item.identifier]?.previous
        }
        return result
    }
    
    public func contains(_ item: T) -> Bool {
        var result:Bool = false
        self.accessQueue.sync {
            result = itemLocating[item.identifier] != nil
        }
        return result
    }
}

extension PagingList {
    
    public enum Traversing {
        case next, previous
    }
    
    public struct Locating {
        public let item: T
        public var previous: T?
        public var next: T?
        
        public init(item: T) {
            self.item = item
        }
    }
}

//Thread safe variables. All related to items array
extension PagingList{
    public var count: Int {
        return self.items.count
    }
    
    public var first: T? {
        return self.items.first
    }
    
    public var last: T? {
        return self.items.last
    }
    
    public var isEmpty: Bool {
        return self.items.isEmpty
    }
}

//Thread safe locating for Unit Test verify.
extension PagingList {
    public subscript(key: String) -> Locating? {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.itemLocating[key] = newValue
            }
        }
        get {
            var result: Locating?
            self.accessQueue.sync {
                result = itemLocating[key]
            }
            return result
        }
    }
}
