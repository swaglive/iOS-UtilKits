//
//  APIRequest.swift
//  Pods
//
//  Created by peter on 2020/11/9.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

public protocol URLStringConvertible {
    func createBuilder() -> URLStringBuilder
}

public class ObjectBuilder<T> {
    public func build() -> T { return T.self as! T}
}

extension String : URLStringConvertible {
    public func createBuilder() -> URLStringBuilder {
        URLStringBuilder(urlString: self)
    }
}

extension URLStringBuilder : URLStringConvertible {
    public func createBuilder() -> URLStringBuilder {
        self
    }
}

public class APIRequest: ObjectBuilder<URLRequest> {
    
    private var urlStringBuilder: URLStringBuilder
    public let method: HTTPMethod

    public class func `public`(method: HTTPMethod, urlString: URLStringConvertible) -> APIRequest {
        return APIRequest(method: method, urlString: urlString).setContentType(.json).setNeedsUserAgent()
    }
    
    public init(method: HTTPMethod, urlString: URLStringConvertible) {
        self.method = method
        self.urlStringBuilder = urlString.createBuilder()
    }
    
    public var request: URLRequest {
        build()
    }

    private var authorization: String = ""
    @discardableResult public func setAuthorization(_ auth: String?) -> APIRequest {
        if let auth = auth {
            self.authorization = auth
        }
        return self
    }
    
    private var contentType: ContentType?
    @discardableResult public func setContentType(_ type: ContentType) -> APIRequest {
        contentType = type
        return self
    }
    
    private var headers: [String: String] = [:]
    @discardableResult public func setHeaders(_ headers: [String: String]?) -> APIRequest {
        guard let headers = headers else { return self }
        self.headers.merge(headers) { $1 }
        return self
    }
    
    private var policy: URLRequest.CachePolicy?
    @discardableResult public func setCachePolicy(_ policy: URLRequest.CachePolicy) -> APIRequest {
        self.policy = policy
        return self
    }
    
    public private(set) var needsUserAgent = false
    @discardableResult public func setNeedsUserAgent(_ needsUserAgent: Bool = true) -> APIRequest {
        self.needsUserAgent = needsUserAgent
        return self
    }
    private var acceptLanguage: String = ""
    @discardableResult public func setAcceptLanguage(_ acceptLanguage: String) -> APIRequest {
        self.acceptLanguage = acceptLanguage
        return self
    }
    
    private var multipartFormData: MultipartFormData?
    @discardableResult public func setMultipartFormdata(_ data: MultipartFormData) -> APIRequest {
        multipartFormData = data
        return self
    }
    
    private var body: Data?
    @discardableResult public func setBody(_ body: Data) -> APIRequest {
        self.body = body
        return self
    }
    
    private var parameters: [String:Any] = [:]
    @discardableResult public func setParameters(_ parameters: [String:Any]?) -> APIRequest {
        guard let parameters = parameters else { return self }
        self.parameters.merge(parameters) { $1 }
        return self
    }
    
    public var baseRequest: URLRequest {
        if method == .head || method == .get {
            var components: [(String, String)] = []
            for (key, value) in parameters {
                components += queryComponents(fromKey: key, value: value)
            }
            
            for (key, value) in components {
                urlStringBuilder = urlStringBuilder.query(key: key, value: value)
            }
        }
        let urlString: String = urlStringBuilder.string
        let url = URL(string: urlString)
        //Make a debug assert for checking URL available
        assert(url != nil)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if authorization.isEmpty == false {
            request.setValue(authorization, forHTTPHeaderField: RequestHeaderKey.authorization)
        }
        
        if let type = contentType {
            request.setValue(type.value, forHTTPHeaderField: type.key)
        }
        

        request.allHTTPHeaderFields = headers
        
        if let policy = self.policy {
            request.cachePolicy = policy
        }
        request.setValue(acceptLanguage, forHTTPHeaderField: RequestHeaderKey.acceptLanguage)
        
        setBody(&request, body: body, parameters: parameters)
        
        return request
    }
}

fileprivate extension APIRequest {

    private func setBody(_ request: inout URLRequest, body: Data?, parameters: [String:Any]) {
        if !(method == .head || method == .get) {
            request.httpBody = parameterData(parameters)
        }
        if let formData = multipartFormData {
            request.setValue(formData.contentTypeValue, forHTTPHeaderField: RequestHeaderKey.contentType)
            request.httpBody = formData.exportData()
        } else if let body = body {
            request.httpBody = body
        }
        
    }
    
    private func parameterData(_ parameters:[String : Any]) -> Data? {
        guard let type = contentType,
            parameters.isEmpty == false
            else { return nil }
        
        switch type {
        case .json:
            return try? JSONSerialization.data(withJSONObject: parameters, options:[])
        case .formURLEncoded:
            let bodyString = combineParameters(parameters)
            return bodyString.data(using: String.Encoding.utf8)
        default:
            return nil
        }
    }
    
    private func combineParameters(_ parameters:[String:Any]) -> String {
        parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(nestedKey)", value: value)
            }
        case let number as NSNumber:
            components.append((key, "\(number)"))
        case let bool as Bool:
            components.append((key, bool.description))
        default:
            components.append((key, "\(value)"))
        }
        return components
    }

}
