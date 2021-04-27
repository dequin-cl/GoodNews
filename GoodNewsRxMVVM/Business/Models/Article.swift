import Foundation
import RxDataSources

struct Article: Hashable, Decodable, Comparable {
    static func < (lhs: Article, rhs: Article) -> Bool {
        rhs.publishedAt < lhs.publishedAt
    }
    
    let title: String
    let description: String?
    let publishedAt: Date
}

extension Article: IdentifiableType {
    var identity: Date {
        return self.publishedAt
    }
    
    typealias Identity = Date
}
