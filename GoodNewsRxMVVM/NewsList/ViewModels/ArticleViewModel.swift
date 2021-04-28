import Foundation
import RxSwift
import RxCocoa

class ArticleListViewModel: DisposableViewModel {
    
    var dataSource = BehaviorRelay<[Article]>(value: [])
    var newsServicesProvider: NewsService
    private var lastPage = 1
    private var isLoading = false
    
    var onFetchArticlesError: ((String)->())?

    var fetchNextArticles = PublishRelay<Void>()
    
    @available(*, unavailable)
    override init() {
      fatalError()
    }
    
    init(newsServicesProvider: NewsService) {
        self.newsServicesProvider = newsServicesProvider
        super.init()

        fetchNextArticles
            .subscribe(onNext: { [weak self] value in
                self?.fetchArticles()
            })
            .disposed(by: disposeBag)
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

