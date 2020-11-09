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
        configuration.httpMaximumConnectionsPerHost = 4
        return URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: sessionQueue)
    }()

    public static var sessionDelegate: URLSessionDelegate?
}
