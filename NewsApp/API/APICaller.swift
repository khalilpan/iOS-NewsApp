//
//  APICaller.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

enum NewsArticlesCallType: String {
    //TODO: - Remove APIKey from APICaller
    case topHeadlines = "https://newsapi.org/v2/top-headlines?country=US&apiKey=da861279e5024fedbb825ccb49495edf"
    case searchQuery = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=da861279e5024fedbb825ccb49495edf&q="
}

enum ArticlesApiCallsDebugPrintType {
    case startCalling
    case successResult
    case errorResult
}

final class APICaller {
    static let sharedInstance = APICaller()
    
    private var url: URL? = nil
    
    public func performGetArticlesCall(callType: NewsArticlesCallType, with query: String?, completion: @escaping  (Result<[Article], Error>) -> Void) {
        
        switch callType {
        case .topHeadlines:
            guard let url = URL(string: NewsArticlesCallType.topHeadlines.rawValue) else { return }
            self.url = url
        case .searchQuery:
            guard let query = query, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            guard let url = URL(string: NewsArticlesCallType.searchQuery.rawValue + query) else { return }
            self.url = url
        }
        
        self.articlesApiCallsDebugPrint(type: .startCalling, callType: callType, dataToPrint: nil)
        
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                self.articlesApiCallsDebugPrint(type: .errorResult,
                                                callType: callType,
                                                dataToPrint: String(describing: error))
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    self.articlesApiCallsDebugPrint(type: .successResult,
                                               callType: callType,
                                               dataToPrint: String(result.articles.count))
                    completion(.success(result.articles))
                } catch {
                    
                    self.articlesApiCallsDebugPrint(type: .errorResult,
                                                    callType: callType,
                                                    dataToPrint: String(describing: error))
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
    
    private func articlesApiCallsDebugPrint(type: ArticlesApiCallsDebugPrintType, callType: NewsArticlesCallType, dataToPrint: String?) {
        /*🔴​🟠​🟡​🟢​🔵​🟣​​⚫️⚪️​🟤​🟠*/
        
        switch type {
        case .startCalling:
            debugPrint("##### CALLING API TYPE -> \(callType) -> \(Date())")
            debugPrint("🔵##### CALLING API URL -> \(callType.rawValue)")
            
        case .successResult:
            debugPrint("##### RESULT API TYPE -> \(callType) -> \(Date())")
            guard let dataToPrint = dataToPrint else { return }
            debugPrint("🟢​##### SUCCESS ARTICLES COUNT -> \(dataToPrint) Articles)")
            
        case .errorResult:
            debugPrint("##### RESULT API TYPE -> \(callType) -> \(Date())")
            guard let dataToPrint = dataToPrint else { return }
            debugPrint("🔴##### ERROR -> \(dataToPrint)")
        }
        debugPrint("**--------------------​----------------------------**")
    }
}
