//
//  DataFileAccess.swift
//  iOS-UtilKits
//
//  Created by peter on 2020/11/9.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class DataFileAccess {
    private static let queue = DispatchQueue(label: "com.swag.datafile.access", attributes: .concurrent)
    
    public class func write(_ data: Data, toURL dataFileWithPathURL: URL) {
        queue.async(flags: .barrier) {
            do {
                try data.write(to: dataFileWithPathURL, options: .atomic)
            } catch (let error) {
                debugPrint("[DataFileAccess] write data failure: \(error.localizedDescription)")
            }
        }
    }
    public class func read(from dataFileWithPathURL: URL) -> Data? {
        guard FileManager.default.fileExists(atPath: dataFileWithPathURL.path) else {
            return nil
        }
        var result: Data?
        queue.sync {
            do {
                result = try Data(contentsOf: dataFileWithPathURL, options: .uncached)
            } catch (let error) {
                debugPrint("[DataFileAccess] read data failure: \(error.localizedDescription)")
            }
        }
        return result
    }
}
