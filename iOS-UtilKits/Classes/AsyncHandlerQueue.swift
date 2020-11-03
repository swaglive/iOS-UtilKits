//
//  AsyncHandlerQueue.swift
//  swagr
//
//  Created by Finn on 2020/9/24.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

protocol AsyncHandlerQueueDelegate: class {
    func fetch<T>(object: T, completion: @escaping (()->()))
}

public class AsyncHandlerQueue<T> {
    weak var delegate: AsyncHandlerQueueDelegate?
    private var queue: [T] = []

    public func add(_ object: T) {
        queue.append(object)
        if queue.count == 1 { nextIfNeeded() }
    }
    
    public func clear() {
        queue = []
    }
    
}

extension AsyncHandlerQueue {
    private func nextIfNeeded() {
        guard let object = queue.first else { return }
        fetch(object: object)
    }
    
    private func fetch(object: T) {
        delegate?.fetch(object: object, completion: { [weak self] in
            guard let me = self else { return }
            me.queue.removeFirst()
            me.nextIfNeeded()
        })
    }
}
