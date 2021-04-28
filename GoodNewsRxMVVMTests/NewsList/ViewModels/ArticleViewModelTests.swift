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
        
    func test_ArticleListViewModel_Creation_Sets_Datasource() {
        
        let sut = makeSUT()

        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: "Set articles on the datasource")
        var result: [Article]?
        
        sut.dataSource.subscribe(onNext: {
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
            XCTAssertEqual([], result)
        }
    }
    
    func test_ArticleListViewModel_Update_Sets_Datasource() {
        let article1 = Article(title: "Test", description: "Description Test", publishedAt: Date.from(iso8601: "2021-04-27T17:35:15Z"))
        let article2 = Article(title: "Test 2", description: "Description Test 2", publishedAt: Date.from(iso8601: "2021-04-26T17:35:15Z"))

        let sut = makeSUT()

        let disposeBag = DisposeBag()
        let expectation = self.expectation(description: "Set articles on the datasource")
        var result: [Article]?
        
        sut.update(withArticle: [article1, article2])
        
        sut.dataSource.subscribe(onNext: {
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
            XCTAssertEqual([article1, article2], result)
        }
    }
    
    func test_fetchNextArticles_Calls_NewsServiceProvider() {
        
        let mock = NewsServiceProvidersMock()
        let articleListVM = makeSUT(newsService: mock)
        
        articleListVM.fetchNextArticles.accept(())
        
        XCTAssertEqual(mock.page, 1)
        XCTAssertNotNil(mock.callback)
        
    }
    
    func test_fetchNextArticles_CallWithError_Calls_OnFetchArticlesError() {
        
        let mock = NewsServiceProvidersErrorMock()
        let sut = makeSUT(newsService: mock)

        let expectation = self.expectation(description: "Error path on fetch")
        
        sut.onFetchArticlesError = { _ in
            expectation.fulfill()
        }
        
        sut.fetchNextArticles.accept(())
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchNextArticles_SuccessfullResponse_Bump_Page() {
        let mock = NewsServiceProvidersSuccessfullMock()
        let sut = makeSUT(newsService: mock)
        
        sut.fetchNextArticles.accept(())
        sut.fetchNextArticles.accept(())
        
        XCTAssertEqual(mock.page, 2)
    }
    
    //MARK:- Helpers
    private func makeSUT(newsService: NewsService = NewsServiceProvidersMock()) -> ArticleListViewModel {
        return ArticleListViewModel(newsServicesProvider: newsService)
    }
}

class NewsServiceProvidersMock: NewsService {
    
    var page = -1
    var callback: (([Article]?, Int, Error?) -> Void)?
    func populateNews(page: Int, _ callback: @escaping (([Article]?, Int, Error?) -> Void)) {
        self.page = page
        self.callback = callback
        callback([], 0, nil)
    }
}

class NewsServiceProvidersErrorMock: NewsService {
    
    var page = -1
    var callback: (([Article]?, Int, Error?) -> Void)?
    func populateNews(page: Int, _ callback: @escaping (([Article]?, Int, Error?) -> Void)) {
        self.page = page
        self.callback = callback
        callback(nil, 0, NSError(domain: "Test", code: 0, userInfo: nil))
    }
}

class NewsServiceProvidersSuccessfullMock: NewsService {
    
    var page = -1
    var callback: (([Article]?, Int, Error?) -> Void)?
    func populateNews(page: Int, _ callback: @escaping (([Article]?, Int, Error?) -> Void)) {
        self.page = page
        self.callback = callback
        
        let article = Article(title: "Test", description: "Description Test", publishedAt: Date.from(iso8601: "2021-04-27T17:35:15Z"))
        
        callback([article], 0, nil)
    }
}

extension Date {
    static func from(iso8601: String) -> Date {
        let dateformatter = ISO8601DateFormatter()
        let date = dateformatter.date(from: iso8601)!
        return date
    }
}
