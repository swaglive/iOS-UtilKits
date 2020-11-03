//
//  MD5Processor.swift
//  swagr
//
//  Created by Kory on 2019/10/18.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation
import CommonCrypto

public struct MD5Processor {
    public init() {}
    
    public func base64Encoded(with url: URL) throws -> String? {
        guard let data = try md5File(url: url) else { return nil }
        return data.base64EncodedString()
    }
    
    public func hexEncoded(with url: URL) throws -> String? {
        guard let data = try md5File(url: url) else { return nil }
        return data.hexEncodedString()
    }
    
    public func md5File(url: URL) throws -> Data? {
        let bufferSize = 10 * 1024 * 1024
        
        do {
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            // Create and initialize MD5 context:
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
            while autoreleasepool(invoking: {
                let data = file.readData(ofLength: bufferSize)
                if data.count > 0 {
                    data.withUnsafeBytes {
                        _ = CC_MD5_Update(&context, $0.baseAddress, numericCast(data.count))
                    }
                    return true // Continue
                } else {
                    return false // End of file
                }
            }) {}
            
            // Compute the MD5 digest:
            var digest: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = CC_MD5_Final(&digest, &context)
            return Data(digest)
        } catch {
            debugPrint("[MD5 Proccess FAILURE] : reason - \(error.localizedDescription)")
            throw error
        }
    }
}

extension Data {
    public func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
