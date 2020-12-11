//
//  PagingListTests.swift
//  swagTests
//
//  Created by Ken on 2019/1/12.
//  Copyright © 2019年 SWAG. All rights reserved.
//

import Foundation
import iOS_UtilKits

import XCTest

class PagingListTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    class T: Identifiable {
        let id: String
        let value: Int
        
        init(id: String, value: Int = 0) {
            self.id = id
            self.value = value
        }
        
        var identifier: String { return id }
    }
    
    func testInit() {
        var list = PagingList<T>()
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list.items.count, 0)
        XCTAssertEqual(list.traversing, .next)
        list = PagingList<T>(traversing: .next)
        XCTAssertEqual(list.traversing, .next)
        list = PagingList<T>(traversing: .previous)
        XCTAssertEqual(list.traversing, .previous)
        let t = T(id: "123")
        list = PagingList<T>(items: [t])
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list.first?.identifier, t.identifier)
        
    }
    
    func testInitLocating() {
        let l = PagingList.Locating(item: T(id: "a"))
        XCTAssertNil(l.previous)
        XCTAssertNil(l.next)
        XCTAssertEqual(l.item.id, "a")
    }
    
    func testLocateItem() {
        let list = PagingList<T>()
        list.append(items: [T(id: "z")])
        list.append(items: [T(id: "a")])
        list.append(items: [T(id: "b")])

        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertEqual(list["a"]?.previous?.id, "z")
        XCTAssertEqual(list["a"]?.next?.id, "b")
    }
    
    func testInsertItems() {
        var list = PagingList<T>(traversing: .next)
        list.append(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.items.count, 3)
        XCTAssertNil(list["a"]?.previous)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertEqual(list["a"]?.next?.id, "b")
        XCTAssertEqual(list["b"]?.previous?.id, "a")
        XCTAssertEqual(list["b"]?.item.id, "b")
        XCTAssertEqual(list["b"]?.next?.id, "c")
        XCTAssertEqual(list["c"]?.previous?.id, "b")
        XCTAssertEqual(list["c"]?.item.id, "c")
        XCTAssertNil(list["c"]?.next)

        list.append(items: [T(id: "d"), T(id: "e")])
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list.items.count, 5)
        XCTAssertEqual(list["c"]?.next?.id, "d")
        XCTAssertEqual(list["d"]?.previous?.id, "c")
        XCTAssertEqual(list["d"]?.item.id, "d")
        XCTAssertEqual(list["d"]?.next?.id, "e")
        XCTAssertEqual(list["e"]?.previous?.id, "d")
        XCTAssertEqual(list["e"]?.item.id, "e")
        XCTAssertNil(list["e"]?.next)

        list = PagingList<T>(traversing: .previous)
        list.append(items: [T(id: "d"), T(id: "e")])
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.items.count, 2)
        XCTAssertNil(list["d"]?.previous)
        XCTAssertEqual(list["d"]?.item.id, "d")
        XCTAssertEqual(list["d"]?.next?.id, "e")
        XCTAssertEqual(list["e"]?.previous?.id, "d")
        XCTAssertEqual(list["e"]?.item.id, "e")
        XCTAssertNil(list["e"]?.next)

        list.append(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list.items.count, 5)
        XCTAssertNil(list["a"]?.previous)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertEqual(list["a"]?.next?.id, "b")
        XCTAssertEqual(list["b"]?.previous?.id, "a")
        XCTAssertEqual(list["b"]?.item.id, "b")
        XCTAssertEqual(list["b"]?.next?.id, "c")
        XCTAssertEqual(list["c"]?.previous?.id, "b")
        XCTAssertEqual(list["c"]?.item.id, "c")
        XCTAssertEqual(list["c"]?.next?.id, "d")
        XCTAssertEqual(list["d"]?.previous?.id, "c")
    }

    func testInsertEdgeItems() {
        var list = PagingList<T>(traversing: .next)
        list.append(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        list.append(items: [T(id: "d")])
        XCTAssertEqual(list["d"]?.previous?.id, "c")
        XCTAssertEqual(list["d"]?.item.id, "d")
        XCTAssertNil(list["d"]?.next)

        list = PagingList<T>(traversing: .previous)
        list.append(items: [T(id: "b"), T(id: "c"),T(id: "d"),])
        list.append(items: [T(id: "a")])
        XCTAssertEqual(list["a"]?.next?.id, "b")
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertNil(list["a"]?.previous)
    }

    func testFilterItems() {
        var list = PagingList<T>(traversing: .next)
        list.append(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        list.append(items: [T(id: "d"), T(id: "b")])
        XCTAssertEqual(list["d"]?.previous?.id, "c")
        XCTAssertEqual(list["d"]?.item.id, "d")
        XCTAssertNil(list["d"]?.next)
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.items.count, 4)

        list = PagingList<T>(traversing: .previous)
        list.append(items: [T(id: "b"), T(id: "c"),T(id: "d"),])
        list.append(items: [T(id: "c"), T(id: "a")])
        XCTAssertEqual(list["a"]?.next?.id, "b")
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertNil(list["a"]?.previous)
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.items.count, 4)
    }

    func testUpdateItem() {
        let list = PagingList<T>(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.items.count, 3)
        XCTAssertEqual(list["b"]?.item.value, 0)
        XCTAssertEqual(list["a"]?.next?.value, 0)
        XCTAssertEqual(list["c"]?.previous?.value, 0)
        
        list.update(item: T(id: "b", value: 1)) {
            XCTAssertEqual(list.count, 3)
            XCTAssertEqual(list.items.count, 3)
            XCTAssertEqual(list["b"]?.item.value, 1)
            XCTAssertEqual(list["a"]?.next?.value, 1)
            XCTAssertEqual(list["c"]?.previous?.value, 1)
        }
    }

    func testQueryItem() {
        let list = PagingList<T>(items: [T(id: "a"), T(id: "b"), T(id: "c")])
        XCTAssertTrue(list.contains(T(id: "a")))
        XCTAssertFalse(list.contains(T(id: "z")))
        XCTAssertNil(list.item(before: T(id: "a")))
        XCTAssertEqual(list.item(before: T(id: "b"))?.id, "a")
        XCTAssertEqual(list.item(before: T(id: "c"))?.id, "b")
        XCTAssertEqual(list.item(after: T(id: "a"))?.id, "b")
        XCTAssertEqual(list.item(after: T(id: "b"))?.id, "c")
        XCTAssertNil(list.item(after: T(id: "c")))
    }

    func testDeleteItem() {
        var list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c")] ,traversing: .next)
        list.delete(item: T(id: "b"))
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.items.count, 2)
        XCTAssertNil(list["a"]?.previous)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertEqual(list["a"]?.next?.id, "c")
        XCTAssertNil(list["b"])
        XCTAssertEqual(list["c"]?.previous?.id, "a")
        XCTAssertEqual(list["c"]?.item.id, "c")
        XCTAssertNil(list["c"]?.next)

        list = PagingList<T>(items:[T(id: "a"), T(id: "b")] ,traversing: .next)
        list.delete(item: T(id: "b"))
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertNil(list["a"]?.previous)
        XCTAssertNil(list["a"]?.next)
        XCTAssertNil(list["b"])

        list = PagingList<T>(items:[T(id: "a"), T(id: "b")] ,traversing: .next)
        list.delete(item: T(id: "a"))
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list["b"]?.item.id, "b")
        XCTAssertNil(list["b"]?.previous)
        XCTAssertNil(list["b"]?.next)
        XCTAssertNil(list["a"])

        list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c")] ,traversing: .next)
        list.delete(at: 1)
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.items.count, 2)
        XCTAssertNil(list["a"]?.previous)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertEqual(list["a"]?.next?.id, "c")
        XCTAssertNil(list["b"])
        XCTAssertEqual(list["c"]?.previous?.id, "a")
        XCTAssertEqual(list["c"]?.item.id, "c")
        XCTAssertNil(list["c"]?.next)

        list = PagingList<T>(items:[T(id: "a"), T(id: "b")] ,traversing: .next)
        list.delete(at: 1)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list["a"]?.item.id, "a")
        XCTAssertNil(list["a"]?.previous)
        XCTAssertNil(list["a"]?.next)
        XCTAssertNil(list["b"])

        list = PagingList<T>(items:[T(id: "a"), T(id: "b")] ,traversing: .next)
        list.delete(at: 0)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list["b"]?.item.id, "b")
        XCTAssertNil(list["b"]?.previous)
        XCTAssertNil(list["b"]?.next)
        XCTAssertNil(list["a"])

        list = PagingList<T>(items:[T(id: "a")] ,traversing: .next)
        list.delete(item: T(id: "a"))
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list.items.count, 0)
        XCTAssertNil(list["a"])

        list = PagingList<T>(items:[T(id: "a")] ,traversing: .next)
        list.delete(at: 0)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list.items.count, 0)
        XCTAssertNil(list["a"])

        //out of bound
        list = PagingList<T>(items:[T(id: "a")] ,traversing: .next)
        list.delete(item: T(id: "b"))
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertNotNil(list["a"])

        list = PagingList<T>(items:[T(id: "a")] ,traversing: .next)
        list.delete(at: 3)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertNotNil(list["a"])
    }

    func testBatchDeleteItem() {
        var list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c"),T(id: "d"),T(id: "e")] ,traversing: .next)
        list.deleteAll(from: 1)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.items.count, 1)
        XCTAssertNotNil(list["a"])
        XCTAssertNil(list["a"]?.previous)
        XCTAssertNil(list["a"]?.next)
        XCTAssertNil(list["b"])
        XCTAssertNil(list["c"])
        XCTAssertNil(list["d"])
        XCTAssertNil(list["e"])

        list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c"),T(id: "d"),T(id: "e")] ,traversing: .next)
        list.deleteAll(from: 0)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list.items.count, 0)
        XCTAssertNil(list["a"])
        XCTAssertNil(list["b"])
        XCTAssertNil(list["c"])
        XCTAssertNil(list["d"])
        XCTAssertNil(list["e"])

        list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c"),T(id: "d"),T(id: "e")] ,traversing: .next)
        list.deleteAll(from: 4)
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.items.count, 4)
        XCTAssertNotNil(list["a"])
        XCTAssertNotNil(list["b"])
        XCTAssertNotNil(list["c"])
        XCTAssertNotNil(list["d"])
        XCTAssertNil(list["e"])

        //out of bound
        list = PagingList<T>(items:[T(id: "a"), T(id: "b"), T(id: "c"),T(id: "d"),T(id: "e")] ,traversing: .next)
        list.deleteAll(from: 5)
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list.items.count, 5)
        XCTAssertNotNil(list["a"])
        XCTAssertNotNil(list["b"])
        XCTAssertNotNil(list["c"])
        XCTAssertNotNil(list["d"])
        XCTAssertNotNil(list["e"])
    }

    func testThreadSafe(){
        let list = PagingList<T>(items:nil ,traversing: .next)
        let expect = XCTestExpectation(description: "Time Out")

        let group = DispatchGroup()
        let queueB = DispatchQueue(label: "queueB", attributes: .concurrent)
        let queueC = DispatchQueue(label: "queueC", attributes: .concurrent)

        list.append(items: [T(id: "a")])
        
        group.enter()
        queueB.sync {
            list.append(items: [T(id: "b")])
            group.leave()
        }

        group.enter()
        queueC.async {
            list.append(items: [T(id: "c")])
            group.leave()
        }

        group.notify(queue: .main) {
            XCTAssertEqual(list.items.map{$0.id}, ["a","b","c"])
            XCTAssertEqual(list.items.count, 3)
            XCTAssertEqual(list.count, 3)
            
            XCTAssertNil(list["a"]?.previous)
            XCTAssertEqual(list["a"]?.next?.identifier, "b")
            XCTAssertEqual(list["b"]?.previous?.identifier, "a")
            XCTAssertEqual(list["b"]?.next?.identifier, "c")
            XCTAssertEqual(list["c"]?.previous?.identifier, "b")
            XCTAssertNil(list["c"]?.next)
            
            XCTAssertEqual(list.first?.id, "a")
            XCTAssertEqual(list.last?.id, "c")
            
            expect.fulfill()
        }

        self.wait(for: [expect], timeout: 0.1)
    }
    
    func testThreadSafeDelete(){
        let list = PagingList<T>(items:[T(id: "a"),T(id: "b"),T(id: "c"),T(id: "d")] ,traversing: .next)
        let expect = XCTestExpectation(description: "Time Out")
        
        let group = DispatchGroup()
        let queueB = DispatchQueue(label: "queueB", attributes: .concurrent)
        let queueC = DispatchQueue(label: "queueC", attributes: .concurrent)
        
        list.delete(item: T(id: "d")) // a b c
        DispatchQueue.global().sync {
            XCTAssertEqual(list.items.count, 3)
            XCTAssertEqual(list.count, 3)
            
            XCTAssertNil(list["a"]?.previous)
            XCTAssertEqual(list["a"]?.next?.identifier, "b")
            XCTAssertEqual(list["b"]?.previous?.identifier, "a")
            XCTAssertEqual(list["b"]?.next?.identifier, "c")
            XCTAssertEqual(list["c"]?.previous?.identifier, "b")
            XCTAssertNil(list["c"]?.next)
        }
        
        
        group.enter()
        queueB.sync {
            list.delete(at: 2) // a b
            
            DispatchQueue.global().sync {
                XCTAssertEqual(list.items.count, 2)
                XCTAssertEqual(list.count, 2)
                
                XCTAssertNil(list["a"]?.previous)
                XCTAssertEqual(list["a"]?.next?.identifier, "b")
                XCTAssertEqual(list["b"]?.previous?.identifier, "a")
                XCTAssertNil(list["b"]?.next)
                group.leave()
            }
        }
        
        group.enter()
        queueC.async {
            list.deleteAll(from: 0)
            group.leave()
        }
        
        group.notify(queue: .main) {
            XCTAssertEqual(list.items.count, 0)
            XCTAssertEqual(list.count, 0)
            
            XCTAssertNil(list["a"])
            XCTAssertNil(list["b"])
            XCTAssertNil(list["c"])
            XCTAssertNil(list["d"])
           
            expect.fulfill()
        }
        
        self.wait(for: [expect], timeout: 0.1)
    }
    
    func testThreadSafeAllConcurrent(){
        
        let list = PagingList<T>(items:nil ,traversing: .next)
        let iterations = 1000
        let group = DispatchGroup()
        let expect = XCTestExpectation(description: "Time Out")
        let testQueue = DispatchQueue(label: "testThreadSafeAllConcurrent")
        
        DispatchQueue.concurrentPerform(iterations: iterations) { (index) in
            group.enter()
            
            testQueue.sync {
                let last = list.last ?? T(id: "0", value: 0)
                let newValue = last.value + 1
                let newItem = T(id: "\(newValue)", value: newValue)
                list.append(items: [newItem])
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            XCTAssertEqual(list.count, iterations)
            XCTAssertEqual(list.items.count, iterations)
            
            XCTAssertTrue(list["1"]?.previous == nil)
            XCTAssertEqual(list["1"]?.next?.identifier, "2")
            XCTAssertEqual(list["50"]?.previous?.identifier, "49")
            XCTAssertEqual(list["50"]?.next?.identifier, "51")
            XCTAssertEqual(list["1000"]?.previous?.identifier, "999")
            XCTAssertTrue(list["1000"]?.next == nil)
            
            XCTAssertEqual(list.first?.id, "1")
            XCTAssertEqual(list.last?.id, "1000")
            expect.fulfill()
        }
        
        self.wait(for: [expect], timeout: 1.0)
    }
}
