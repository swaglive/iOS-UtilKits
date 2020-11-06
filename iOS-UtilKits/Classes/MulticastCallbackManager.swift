//
//  MulticastCallbackManager.swift
//  swag
//
//  Created by Mike Yu on 28/09/2017.
//  Copyright © SWAG. All rights reserved.
//

import Foundation

public typealias CallbackToken = MulticastCallbackRegistration

public class MulticastCallbackManager<CallbackType>: MulticastCallbackUnregistering {
    fileprivate var handlers = [UUID: CallbackType]() {
        didSet {
            if oldValue.count != handlers.count {
                observersDidChangeHandler?()
            }
        }
    }
    public var observersDidChangeHandler: (() -> ())?
    
    public init() {}
    
    public func add(_ handler: CallbackType) -> CallbackToken {
        return MulticastCallbackRegistration(uuid: addHandlerAndGenerateToken(handler), unregisterResponder: self)
    }
    
    public func addAutoRemovingHandler(_ handler: CallbackType) -> CallbackToken {
        return AutoRemovingMulticastCallbackRegistration(uuid: addHandlerAndGenerateToken(handler), unregisterResponder: self)
    }
    
    private func addHandlerAndGenerateToken(_ handler: CallbackType) -> UUID {
        let uuid = UUID()
        handlers[uuid] = handler
        return uuid
    }

    public func remove(with token: Any) {
        if let registration = token as? MulticastCallbackRegistration {
            remove(with: registration.uuid)
        } else if let uuid = token as? UUID {
            remove(with: uuid)
        } else {
            assertionFailure("[Multicast Callback]Unrecognized token type: \(token)")
        }
    }
    
    fileprivate func remove(with uuid: UUID) {
        if handlers.removeValue(forKey: uuid) == nil {
            debugPrint("[Multicast Callback]Callback associated with token \"\(uuid)\" is not found")
        }
    }
    
    public func invokeEach(_ invocation:(CallbackType)->()) {
        handlers.values.forEach{invocation($0)}
    }
    
    public var isEmpty: Bool {
        return handlers.isEmpty
    }
}

public protocol MulticastCallbackUnregistering {
    func remove(with token: Any)
}

public class MulticastCallbackRegistration {
    fileprivate let uuid: UUID
    fileprivate let unregisterResponder: MulticastCallbackUnregistering
    public init(uuid: UUID, unregisterResponder: MulticastCallbackUnregistering) {
        self.uuid = uuid
        self.unregisterResponder = unregisterResponder
    }
    public func unregister() {
        unregisterResponder.remove(with: self)
    }
}

fileprivate class AutoRemovingMulticastCallbackRegistration: MulticastCallbackRegistration {
    deinit {
        unregister()
    }
}

extension MulticastCallbackManager: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "<MulticastCallbackManager: \(memoryAddress(of: self))>{ count: \(handlers.count), handlers: \(handlers) }"
    }
}
