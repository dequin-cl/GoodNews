//
//  ConfigurationTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
@testable import GoodNewsRxMVVM

class ConfigurationTests: XCTestCase {

    func test_UrlForNewsAPI_SetApiKey() {
        urlContains(
            url: Configuration.urlForNewsAPI(page: 0),
            query: URLQueryItem(name: "apiKey", value: APIKEY)
        )
    }
    
    func test_UrlForNewsAPI_SetPageSize_to_10() {
        urlContains(
            url: Configuration.urlForNewsAPI(page: 0),
            query: URLQueryItem(name: "pageSize", value: "10")
        )
    }
    
    func test_UrlForNewsAPI_SetPage() {
        urlContains(
            url: Configuration.urlForNewsAPI(page: 10),
            query: URLQueryItem(name: "page", value: "10")
        )
    }
    
    func test_UrlForNewsAPI_SetUSCountry() {
        urlContains(
            url: Configuration.urlForNewsAPI(page: 0),
            query: URLQueryItem(name: "country", value: "us")
        )
    }
    
    //MARK:- Helpers
    
    func urlContains(url: URL, query: URLQueryItem, file: StaticString = #filePath, line: UInt = #line) {
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components?.queryItems)

        let queryItems = components!.queryItems!
        XCTAssertTrue(queryItems.contains(query))
    }
}
