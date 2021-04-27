import Foundation

protocol NewsService {
    func populateNews(page: Int, _ callback: @escaping (([Article]?, Int, Error?) -> Void))
}
