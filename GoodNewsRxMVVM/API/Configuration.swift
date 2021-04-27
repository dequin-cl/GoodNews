import Foundation

struct Configuration {
    private static let base = "https://newsapi.org/v2/top-headlines"
    private static let apikey = "apiKey=\(APIKEY)"
    private static let pageSize = "pageSize=10"
    private static let page = "page"
    
    static func urlForNewsAPI(page: Int) -> URL {
        
        var urlComponents = URLComponents.init(string: base)
        
        let queryItemApiKey = URLQueryItem(name: "apiKey", value: apikey)
        let queryItemPageSize = URLQueryItem(name: "pageSize", value: "10")
        let queryItemPage = URLQueryItem(name: "page", value: "\(page)")
        let queryItemCountry = URLQueryItem(name: "country", value: "us")

        urlComponents?.queryItems = [
            queryItemApiKey,
            queryItemPageSize,
            queryItemPage,
            queryItemCountry
        ]
        
        guard let url = urlComponents?.url else {
            fatalError("Could not build URL")
        }
        
        return url
    }
}
