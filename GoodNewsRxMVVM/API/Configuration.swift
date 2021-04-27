import Foundation

struct Configuration {
    private init() {}
    
    private static let base = "https://newsapi.org/v2/top-headlines"
    
    static func urlForNewsAPI(page: Int) -> URL {
        
        var urlComponents = URLComponents.init(string: base)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "apiKey", value: APIKEY),
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "country", value: "us")
        ]
        
        guard let url = urlComponents?.url else {
            fatalError("Could not build URL")
        }
        
        return url
    }
}
