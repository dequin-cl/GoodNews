import Foundation
import RxSwift
import RxCocoa

class ArticleListViewModel: DisposableViewModel {
    
    var dataSource = BehaviorRelay<[Article]>(value: [])
    var newsServicesProvider: NewsService = NewsServiceProviders()
    private var lastPage = 1
    private var isLoading = false
    
    var onFetchArticlesError: ((String)->())?

    var fetchNextArticles = PublishRelay<Void>()
    
    init(withArticle articles: [Article]) {
        super.init()
        
        fetchNextArticles.subscribe(onNext: { [weak self] value in
            self?.fetchArticles()
        }).disposed(by: disposeBag)
        
        if articles.isEmpty {
            dataSource.accept([])
        } else {
            print("Number of articles: \(articles.count)")
            dataSource.accept(articles)
        }
    }
    
    func update(withArticle articles: [Article]) {
        dataSource.accept(combine(dataSource.value, articles).sorted())
    }

    func combine<T:Hashable>(_ arrays: Array<T>?...) -> Array<T> {
        return Array(arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)})
    }
    
    private func fetchArticles() {
        guard !isLoading else { return}
        
        isLoading = true
        newsServicesProvider.populateNews(page: lastPage){ [weak self] (articles, totalResults, error)  in
            guard let articles = articles else {
                self?.onFetchArticlesError?("Could not download News. Please try later")
                return
            }
            
            if !articles.isEmpty {
                self?.lastPage += 1
            }
            
            self?.update(withArticle: articles)
            self?.isLoading = false
            
        }
        
    }
}

