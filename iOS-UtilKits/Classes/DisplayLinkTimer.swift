//
//  DisplayLinkTimer.swift
//  swag
//
//  Created by peter on 2018/3/1.
//  Copyright © 2018年 Machipopo Corp. All rights reserved.
//

import Foundation
import QuartzCore

@objcMembers
public class DisplayLinkTimer: NSObject {
    private var displayLink: CADisplayLink!
    private var updateHandler: ((DisplayLinkTimer) -> ())?
    
    public init(framesPerSecond: Int, updateHandler: ((DisplayLinkTimer) -> ())? ) {
        self.updateHandler = updateHandler
        super.init()
        displayLink = CADisplayLink(target: self, selector: #selector(update(displayLink:)))
        displayLink.isPaused = true
        displayLink.preferredFramesPerSecond = framesPerSecond
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }
    
    public func pause() {
        displayLink.isPaused = true
    }
    
    public func resume() {
        displayLink.isPaused = false
    }
    
    public func invalidate() {
        displayLink.isPaused = true
        displayLink.invalidate()
    }
    
    @objc private func update(displayLink: CADisplayLink) {
        updateHandler?(self)
    }
}
