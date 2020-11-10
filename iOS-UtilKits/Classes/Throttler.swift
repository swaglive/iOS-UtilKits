//
//  Throttler.swift
//  swagr
//
//  Created by peter on 2020/10/5.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class Throttler: NSObject {

    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval

    public init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    public func throttle(_ block: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem() {
            [weak self] in
            self?.previousRun = Date()
            block()
        }

        let period = abs(previousRun.timeIntervalSinceNow)
        let delay = period > minimumDelay ? 0 : minimumDelay

        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}
