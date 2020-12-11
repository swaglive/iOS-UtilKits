//
//  URLStringBuilder.swift
//  Pods
//
//  Created by peter on 2020/11/9.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

public class URLStringBuilder {
    private struct QueryItem {
        let key: String
        let value: String
    }
    private var base: String
    private var paths: [String] = []
    private var query: [QueryItem] = []
    private var extensionFormat: String?
    
    /// The urlString must be an legal URL string; otherwise, builder will return an empty string.
    /// - Parameter urlString: the domain of the URL.
    public init(urlString: String) {
        self.base = urlString
    }
    
    public func path(_ path: String) -> URLStringBuilder {
        paths.append(path)
        return self
    }
    
    public func query(key: String, value: String) -> URLStringBuilder {
        query.append(QueryItem(key: key, value: value))
        return self
    }
    
    public func `extension`(_ ext: String) -> URLStringBuilder {
        extensionFormat = ext
        return self
    }

    /// Build the an URL string with the components. If the base URLString is illegal, then will get empty String.
    public var string: String {
        return build()
    }
    
    private func build() -> String {
        guard let baseString = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var url = URL(string: baseString) else {
                assert(false, "the base url is illegal.")
                return ""
        }
        
        for path in paths {
            url.appendPathComponent(path)
        }
        
        if let ext = extensionFormat {
            url.appendPathExtension(ext)
        }
        
        if var comp = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !query.isEmpty {
            let querys = query.sorted {$0.key < $1.key}.map({ URLQueryItem(name: $0.key, value: $0.value) }) as [URLQueryItem]
            var items = comp.queryItems ?? []
            items.append(contentsOf: querys)
            comp.queryItems = items
            if let newUrl = comp.url {
                url = newUrl
            }
        }
        
        return url.absoluteString
    }
}
