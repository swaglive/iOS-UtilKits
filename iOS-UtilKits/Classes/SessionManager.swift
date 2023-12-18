//
//  SessionManager.swift
//  Pods
//
//  Created by peter on 2020/11/9.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class SessionManager : NSObject {
    public static var sessionQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "swag.session.queue"
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
    
    public static let session: URLSession =  {
        let configuration = URLSessionConfiguration.default
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        configuration.urlCache = URLCache(
            memoryCapacity: 25 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            directory: cachesURL.appendingPathComponent("HTTPCache")
        )
        return URLSession(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: sessionQueue)
    }()
    
    public static let sessionWithNoCache: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 4
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return URLSession(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: sessionQueue
        )
    } ()

    public static var sessionDelegate: URLSessionDelegate?
}
