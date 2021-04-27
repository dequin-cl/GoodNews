import Foundation
import RxSwift
import RxCocoa

class ArticleListViewModel: DisposableViewModel {
    var dataSource = BehaviorRelay<[Article]>(value: [])

    init(withArticle articles: [Article]) {
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
}

