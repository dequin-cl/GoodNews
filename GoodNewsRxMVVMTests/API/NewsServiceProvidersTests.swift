//
//  NewsServiceProvidersTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
import Hippolyte
@testable import GoodNewsRxMVVM

class NewsServiceProvidersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Hippolyte.shared.stop()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_Service_DeliverNews() {
        let url = Configuration.urlForNewsAPI(page: 0)
        var stub = StubRequest(method: .GET, url: url)
        
        var response = StubResponse()
        let path = Bundle(for: type(of: self)).path(forResource: "NewsSample", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        
        response.body = body as Data
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()

        let expectation = self.expectation(description: "Stubs network call")

        let provider = NewsServiceProviders()
        
        provider.populateNews(page: 0) { articles, totalResults, error in
            XCTAssertNil(error)
            XCTAssertNotNil(articles)
            XCTAssertEqual(articles!.count, 8)
            XCTAssertEqual(totalResults, 38)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)

    }
    
    func test_Service_ReportErrorOn_ResponseErrorStatus() {
        let url = Configuration.urlForNewsAPI(page: 0)
        var stub = StubRequest(method: .GET, url: url)
        let response = StubResponse.Builder()
            .stubResponse(withStatusCode: 400)
            .build()
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        
        let expectation = self.expectation(description: "Stubs network call")

        let provider = NewsServiceProviders()
        
        provider.populateNews(page: 0) { _, _, error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testStub() {
      let url = URL(string: "http://www.apple.com")!
      var stub = StubRequest(method: .GET, url: url)
      var response = StubResponse()
      let body = "Hippolyte".data(using: .utf8)!
      response.body = body
      stub.response = response
      Hippolyte.shared.add(stubbedRequest: stub)
      Hippolyte.shared.start()

      let expectation = self.expectation(description: "Stubs network call")
      let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        XCTAssertEqual(data, body)
        expectation.fulfill()
      }
      task.resume()

      wait(for: [expectation], timeout: 1)
    }

}
