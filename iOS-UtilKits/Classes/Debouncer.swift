//
//  Debouncer.swift
//  swagr
//
//  Created by peter on 2020/10/5.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class Debouncer: NSObject {
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private let semaphore: DebouncerSemaphore
    private var workItem: DispatchWorkItem?

    public init(seconds: TimeInterval, qos: DispatchQoS = .default) {
        interval = seconds
        semaphore = DebouncerSemaphore(value: 1)
        queue = DispatchQueue(label: "swag.debouncer.queue", qos: qos)
    }
    
    public func invoke(_ action: @escaping (() -> Void)) {
        semaphore.sync {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: {
                action()
            })
            if let item = workItem {
                queue.asyncAfter(deadline: .now() + self.interval, execute: item)
            }
        }
    }
    
    public func cancel() {
        workItem?.cancel()
    }
}

fileprivate struct DebouncerSemaphore {
    private let semaphore: DispatchSemaphore
    
    init(value: Int) {
        semaphore = DispatchSemaphore(value: value)
    }
    
    func sync(execute: () -> Void) {
        defer { semaphore.signal() }
        semaphore.wait()
        execute()
    }
}
