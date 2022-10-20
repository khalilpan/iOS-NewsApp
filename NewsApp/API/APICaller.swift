//
//  APICaller.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

enum NewsUrls: String {
    //TODO: - Remove APIKey from APICaller
    case topHeadlines = "https://newsapi.org/v2/top-headlines?country=br&apiKey=da861279e5024fedbb825ccb49495edf"
}

final class APICaller {
    static let sharedInstance = APICaller()
    
    private init() {}
    
    public func getTopStories(completion: @escaping  (Result<[Article], Error>) -> Void ) {
        guard let url = URL(string: NewsUrls.topHeadlines.rawValue) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                } catch {
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
