//
//  APICaller.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

enum NewsUrls: String {
    case topHeadlines = "https://newsapi.org/v2/top-headlines?country=us&apiKey=da861279e5024fedbb825ccb49495edf"
}

final class APICaller {
    static let sharedInstance = APICaller()
    
    private init() {}
    
    public func getTopStories(completion: @escaping  (Result<[String], Error>) -> Void ) {
        guard let url = URL(string: NewsUrls.topHeadlines.rawValue) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result)")
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}