import RxSwift

struct NewsServiceProviders: NewsService {
    let disposeBag = DisposeBag()
    
    func populateNews(page: Int, _ callback: @escaping (([Article]?, Int, Error?) -> Void)) {
        
        APIService.load(resource: ArticleList.all(page: page))
            .materialize()
            .subscribe(onNext: { event in
                switch event {
                case .error(let error):
                    callback(nil, 0, error)
                    break
                case .next(let articleList):
                    callback(articleList.articles, articleList.totalResults, nil)
                    break
                default: break
                }
                
            }).disposed(by: disposeBag)
    }
    
    
}
