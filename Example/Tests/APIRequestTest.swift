//
//  APIRequestTest.swift
//  swagrTests
//
//  Created by peter on 2019/4/25.
//  Copyright © 2019 SWAG. All rights reserved.
//

import XCTest
import Foundation
import iOS_UtilKits

extension APIRequest {
    public override func build() -> URLRequest {
        var request = baseRequest
        if needsUserAgent {
            request.setValue("UserAgent", forHTTPHeaderField: RequestHeaderKey.userAgent)
        }
        return request
    }
}


class APIRequestTest: XCTestCase {
    let swagDomain = "https://www.swag.live"
    func testBasicInit() {
        let req = APIRequest(method: .get, urlString: swagDomain)
        XCTAssertEqual(req.request.url!.absoluteString, swagDomain)
    }
    
    func testGETMethod() {
        let req = APIRequest(method: .get, urlString: swagDomain)
        XCTAssertEqual(req.request.httpMethod, "GET")
    }
    
    func testURLEncodingQuery() {
        let baseURL = "https://www.swag.live?test=test|1"
        let escapedString = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setParameters(["test":"test|1"])
        XCTAssertEqual(req.request.url!.absoluteString, escapedString)
    }
    
    func testAuthorization() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setAuthorization("Bearer aaa.bbbb.cccc")
        XCTAssertNotNil(req.request.allHTTPHeaderFields?["Authorization"])
    }
    
    func testContentType() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setContentType(.formURLEncoded)
        XCTAssertNotNil(req.request.allHTTPHeaderFields?["Content-Type"])
    }
    
    func testCachePolicy() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setCachePolicy(.reloadIgnoringCacheData)
        XCTAssertEqual(req.request.cachePolicy, URLRequest.CachePolicy.reloadIgnoringCacheData)
    }
    
    func testUserAgent() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setNeedsUserAgent()
        XCTAssertNotNil(req.request.allHTTPHeaderFields?["User-Agent"])
    }
    
    func testDefaultAcceptLanguage() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setAcceptLanguage("en-us")
        XCTAssertNotNil(req.request.allHTTPHeaderFields?["Accept-Language"])
    }
    
    func testCustomAcceptLanguage() {
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setAcceptLanguage("en-us")
        XCTAssertEqual(req.request.allHTTPHeaderFields?["Accept-Language"], "en-us")
    }
    
    func testFormDataContentType() {
        let formData = MultipartFormData()
        let req = APIRequest(method: .post, urlString: swagDomain)
            .setMultipartFormdata(formData)
        XCTAssertNotNil(req.request.allHTTPHeaderFields?["Content-Type"])
    }
    
    func testFormData() {
        let formData = MultipartFormData()
        let req = APIRequest(method: .post, urlString: swagDomain)
            .setMultipartFormdata(formData)
        XCTAssertEqual(req.request.httpBody, formData.exportData())
    }
    
    func testBodyData() {
        let data = Data()
        let req = APIRequest(method: .get, urlString: swagDomain)
            .setBody(data)
        XCTAssertEqual(req.request.httpBody, data)
    }
    
    func testSingleHeader() {
        let req = APIRequest(method: .put, urlString: swagDomain)
            .setHeaders(["key": "value"])
        let allHeaders = req.request.allHTTPHeaderFields!
        XCTAssertEqual(allHeaders["key"]!, "value")
    }
    
    func testMultipleHeader() {
        let req = APIRequest(method: .put, urlString: swagDomain)
            .setHeaders(["key": "value"])
            .setHeaders(["key1": "value1"])
        let allHeaders = req.request.allHTTPHeaderFields!
        XCTAssertEqual(allHeaders["key"]!, "value")
        XCTAssertEqual(allHeaders["key1"]!, "value1")
    }
    
    func testQueryParameters() {
        let req = APIRequest(method: .head, urlString: swagDomain)
            .setParameters(["key": "value"])
        let urlComponent = URLComponents(url: req.request.url!, resolvingAgainstBaseURL: false)
        
        let item = urlComponent?.queryItems?.filter( {$0.name == "key" && $0.value == "value"} )
        XCTAssertNotNil(item)
        XCTAssert(item?.count == 1)
    }
    
    func testPostJSON() {
        let req = APIRequest(method: .post, urlString: swagDomain)
            .setContentType(.json)
            .setParameters(["key": "value"])

        let body = req.request.httpBody!
        let jsonDict = try! JSONSerialization.jsonObject(with: body, options: [.allowFragments]) as! [String: String]
        XCTAssert(jsonDict["key"] == "value")
    }
    
    func testPostFromURLEncode() {
        let req = APIRequest(method: .post, urlString: swagDomain)
            .setContentType(.formURLEncoded)
            .setParameters(["key": "value"])
        
        let body = req.request.httpBody!
        let bodyString = String(data: body, encoding: .utf8)
        XCTAssert(bodyString == "key=value")
    }
}
