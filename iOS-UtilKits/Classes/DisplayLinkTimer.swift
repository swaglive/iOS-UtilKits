//
//  DisplayLinkTimer.swift
//  swag
//
//  Created by peter on 2018/3/1.
//  Copyright © SWAG. All rights reserved.
//

import Foundation
import QuartzCore

public enum DisplayLinkTimerState {
    case resume
    case pause
    case invalidate
    case `deinit`
}

public protocol DisplayLinkTimerDelegate: AnyObject {
    func stateUpdated(_ state: DisplayLinkTimerState)
}

@objcMembers
public class DisplayLinkTimer: NSObject {
    private var displayLink: CADisplayLink!
    private var updateHandler: ((DisplayLinkTimer) -> ())?
    public weak var delegate: DisplayLinkTimerDelegate?

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
        delegate?.stateUpdated(.pause)
    }
    
    public func resume() {
        displayLink.isPaused = false
        delegate?.stateUpdated(.resume)

    }
    
    public func invalidate() {
        displayLink.isPaused = true
        delegate?.stateUpdated(.invalidate)
        displayLink.invalidate()
    }
    
    @objc private func update(displayLink: CADisplayLink) {
        updateHandler?(self)
    }
    
    deinit {
        delegate?.stateUpdated(.deinit)
    }
}
