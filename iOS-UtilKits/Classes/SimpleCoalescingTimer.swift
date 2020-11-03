//
//  SimpleCoalescingTimer.swift
//  lit
//
//  Created by Mike Yu on 2016/10/22.
//  Copyright © 2016年 17 Media. All rights reserved.
//

import Foundation

@objcMembers
public class SimpleCoalescingTimer: NSObject {
    let task: ()->()
    let delay: TimeInterval
    
    public init(delay: TimeInterval = 0.5, task: @escaping ()->()) {
        self.task = task
        self.delay = delay
    }
    
    private weak var timer: Timer?
    
    public func reschedule() {
        cancel()
        DispatchQueue.main.async(execute: scheduleTimer)
    }
    
    private func scheduleTimer() {
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(invokeTask), userInfo: nil, repeats: false)
    }
    
    @objc private func invokeTask() {
        self.task()
    }
    
    public func cancel() {
        timer?.invalidate()
    }
    deinit {
        cancel()
    }
}
