//
//  ArticleViewModelTests.swift
//  GoodNewsRxMVVMTests
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import XCTest
import RxSwift
import RxCocoa
@testable import GoodNewsRxMVVM

class ArticleViewModelTests: XCTestCase {
    let article1 = Article(title: "Test", description: "Description Test", publishedAt: Date.from(iso8601: "2021-04-27T17:35:15Z"))
    let article2 = Article(title: "Test 2", description: "Description Test 2", publishedAt: Date.from(iso8601: "2021-04-26T17:35:15Z"))

    let article3 = Article(title: "Test 3", description: "Description Test 3", publishedAt: Date.from(iso8601: "2021-04-25T17:35:15Z"))
    let article4 = Article(title: "Test 4", description: "Description Test 4", publishedAt: Date.from(iso8601: "2021-04-24T17:35:15Z"))

//    func test_ArticleListViewModel_Creation_Sets_Datasource() {
//        let articleListVM = ArticleListViewModel(withArticle: [article1, article2])
//
//        XCTAssertEqual(articleListVM.dataSource.value.count, 2)
//
//        XCTAssertEqual(articleListVM.dataSource.value[0], article1)
//    }
    
    func test_ArticleListViewModel_Creation_Sets_Datasource() {
        let articleListVM = ArticleListViewModel(withArticle: [article1, article2])
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: "Set articles on the datasource")
        var result: [Article]?
        
        articleListVM.dataSource.subscribe(onNext: {
            result = $0
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0) { error in
          guard error == nil else {
            XCTFail(error!.localizedDescription)
            return
          }

          // 5
            XCTAssertEqual([self.article1, self.article2], result)
        }
    }
    
    func test_ArticleListViewModel_Update_Sets_Datasource() {
        let articleListVM = ArticleListViewModel(withArticle: [article1, article2])
        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: "Set articles on the datasource")
        var result: [Article]?
        
        articleListVM.update(withArticle: [article3, article4])

        articleListVM.dataSource.subscribe(onNext: {
            result = $0
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        
        waitForExpectations(timeout: 1.0) { error in
          guard error == nil else {
            XCTFail(error!.localizedDescription)
            return
          }

          // 5
            XCTAssertEqual([self.article1, self.article2, self.article3, self.article4], result)
        }
    }
}

extension Date {
    static func from(iso8601: String) -> Date {
        let dateformatter = ISO8601DateFormatter()
        let date = dateformatter.date(from: iso8601)!
        return date
    }
}
