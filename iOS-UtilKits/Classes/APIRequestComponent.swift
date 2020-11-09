//
//  APIRequestComponent.swift
//  swagr
//
//  Created by Kory on 2020/3/11.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

public enum HTTPMethod: String{
    case head = "HEAD"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum ContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case octetStream = "application/octet-stream"
    case imageMimeType = "image/jpeg"
    public static let headerKeyName = "Content-Type"
    
    public var key: String {
        return ContentType.headerKeyName
    }
    public var value: String {
        return self.rawValue
    }
}

public struct RequestHeaderKey {
    public static let authorization = "Authorization"
    public static let contentType = "Content-Type"
    public static let userAgent = "User-Agent"
    public static let acceptLanguage = "Accept-Language"
}

public class MultipartFormData {
    public var body = Data()
    public let boundary: String

    public var contentTypeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    public init() {
        self.boundary = UUID().uuidString
    }

    public func append(data: Data,
                name: String,
                filename: String,
                mimeType: String) {
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(data)
        body.append(Data("\r\n".utf8))
    }

    public func exportData() -> Data {
        var output = body
        output.append(Data("--\(boundary)--\r\n".utf8))
        return output
    }
}
