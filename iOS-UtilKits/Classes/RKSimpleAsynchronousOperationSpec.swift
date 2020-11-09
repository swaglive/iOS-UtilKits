//
//  RKSimpleAsynchronousOperationSpec.swift
//  swag
//
//  Created by Hokila Jan on 2019/1/10.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

// For Anyone want mock RKSimpleAsynchronousOperation
public protocol RKSimpleAsynchronousOperationSpec {
    var success: Bool? {get}
    var error: Error? {get}
    var completionBlock:(()->Void)? { get set}
    func start()
    func cancel()
    func finish()
}
