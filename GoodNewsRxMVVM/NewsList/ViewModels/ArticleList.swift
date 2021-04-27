import Foundation

struct ArticleList: Decodable {
    let totalResults: Int
    let articles: [Article]
}

extension ArticleList {
    static func all(page: Int) -> Resource<ArticleList> {
        return Resource(url: Configuration.urlForNewsAPI(page: page))
    }
}
