//
//  URL+Extension.swift
//  Pods
//
//  Created by peter on 2020/11/9.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

extension URL {
    
    public func addingQueryItems(_ items: [String: String]) -> URL? {
        guard var comp = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        var merged = comp.queryItems ?? []
        merged += items.map{URLQueryItem(name: $0.key, value: $0.value)}
        comp.queryItems = merged
        return comp.url
    }

    public func appendingQueryParameters(_ parameters:[String:Any]?) -> URL? {
        var retVal:URL?
        if let params = parameters {
            var urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: false)

            var merged = urlComponent?.queryItems ?? []
            let appendingItems = buildQueryItems(fromDictionary:params)
            merged += appendingItems
            
            urlComponent?.queryItems = merged
            retVal = urlComponent?.url
        }
        return retVal
    }
    
    public func buildQueryItems(fromDictionary parameters: [String:Any]) -> [URLQueryItem] {
        var queryItems:[URLQueryItem] = []
        for (k,value) in parameters {
            switch value.self {
            case is String:
                let queryItem = URLQueryItem(name: k, value: (value as? String))
                queryItems.append(queryItem)
            case is NSNumber:
                let queryItem = URLQueryItem(name: k, value: (value as? NSNumber)?.stringValue)
                queryItems.append(queryItem)
            case is Int:
                let queryItem = URLQueryItem(name: k, value: String(value as? Int ?? 0))
                queryItems.append(queryItem)
            default: break
            }
        }
        return queryItems
    }
}
