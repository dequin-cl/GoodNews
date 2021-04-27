import RxCocoa

class ArticleListCellViewModel {
    var title: Driver<String>
    var description: Driver<String>
    
    init(withArticle article: Article) {
        title = .just(article.title)
        description = .just(article.description ?? "")
    }
}
