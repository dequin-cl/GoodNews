//
//  ArticleTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
@testable import GoodNewsRxMVVM

class ArticleTests: XCTestCase {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func test_Creation_from_json() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "SingleNews", ofType: "json")!
        let data = NSData(contentsOfFile: path)!

        let article = try decoder.decode(Article.self, from: data as Data)
        
        XCTAssertEqual(article.description, "Trevor Noah, Stephen Colbert and Jimmy Fallon on their shows Monday night homed in on the 'Judas and the Black Messiah' Oscar winner's quip about his parents while his mom was in the audience.")
        XCTAssertEqual(article.title, "Late Night Hosts Celebrate Daniel Kaluuya's Awkward Oscars Sex Joke - Hollywood Reporter")
        
        let dateformatter = ISO8601DateFormatter()
        let date = dateformatter.date(from: "2021-04-27T04:09:46Z")
        
        XCTAssertEqual(article.publishedAt, date)
        
        XCTAssertEqual(article.identity, article.publishedAt)
    }

}
