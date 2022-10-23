//
//  APICaller.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

enum NewsArticlesCallType: String {
    case topHeadlines = "https://newsapi.org/v2/top-headlines?"
    case searchQuery = "https://newsapi.org/v2/everything?"
}

enum NewsArticlesUrlParameters: String {
    //TODO: - Remove APIKey from APICaller
    case apiKey = "&apiKey=da861279e5024fedbb825ccb49495edf"
    case country = "country=US"
    case sortBy = "sortBy=popularity"
    case query = "&q="
}

enum ArticlesApiCallsDebugPrintType {
    case startCalling
    case successResult
    case errorResult
}

protocol NewsApiRepositoryProtocol {
    func performApiNewsGetCall<T>(callType: NewsArticlesCallType, with query: String?, completion: @escaping (Result<T, Error>) -> Void)
    func fetchImage(url: URL, completion: @escaping  (Result<Data, Error>) -> Void)
}

final class NewsApiRepository {
    static let sharedInstance = NewsApiRepository()
    
    private func getUrl(callType: NewsArticlesCallType, with query: String?) -> URL? {
        
        var url: URL? = nil
        
        switch callType {
        case .topHeadlines:
            let urlString = NewsArticlesCallType.topHeadlines.rawValue +
            NewsArticlesUrlParameters.country.rawValue +
            NewsArticlesUrlParameters.apiKey.rawValue
            guard let urlToUse = URL(string: urlString) else { return nil}
            url = urlToUse
        case .searchQuery:
            guard let query = query, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return nil}
            let urlString = NewsArticlesCallType.searchQuery.rawValue +
            NewsArticlesUrlParameters.sortBy.rawValue +
            NewsArticlesUrlParameters.apiKey.rawValue +
            NewsArticlesUrlParameters.query.rawValue +
            query
            guard let urlToUse = URL(string: urlString) else { return nil}
            url = urlToUse
        }
        
        return url
    }
}

//MARK: - NewsApiRepositoryProtocol, ArticlesApiCallsDebugPrintProtocol
extension NewsApiRepository: NewsApiRepositoryProtocol, ArticlesApiCallsDebugPrintProtocol {
    public func performApiNewsGetCall<T>(callType: NewsArticlesCallType, with query: String?, completion: @escaping (Result<T, Error>) -> Void) {
        let url: URL? = getUrl(callType: callType, with: query)
        
        self.articlesApiCallsDebugPrint(type: .startCalling, callType: callType, dataToPrint: url?.absoluteString)
        
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                self.articlesApiCallsDebugPrint(type: .errorResult, callType: callType, dataToPrint: String(describing: error))
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    self.articlesApiCallsDebugPrint(type: .successResult, callType: callType, dataToPrint: String(result.articles.count))
                    if let articlesToReturn = result.articles as? T {
                        completion(.success(articlesToReturn))
                    }
                } catch {
                    self.articlesApiCallsDebugPrint(type: .errorResult, callType: callType, dataToPrint: String(describing: error))
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func fetchImage(url: URL, completion: @escaping  (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}
