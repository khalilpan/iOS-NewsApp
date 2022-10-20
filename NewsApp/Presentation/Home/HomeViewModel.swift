//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

protocol TopHeadlinesFetchDelegate: AnyObject {
    func loadingStarted()
    func loadingFinished()
}

struct HomeTableViewCellType {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String,
         subtitle: String,
         imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class HomeViewModel {
    var headLines: [HomeTableViewCellType] = []
    var articles: [Article] = []
    weak var delegate: TopHeadlinesFetchDelegate?
    
    func fetchHealdLines() {
        self.delegate?.loadingStarted()
        APICaller.sharedInstance.getTopStories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.articles = response
                self.headLines = response.compactMap({ HomeTableViewCellType(
                    title: $0.title ?? "No Title",
                    subtitle: $0.description ?? "No Description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
                })
                
                self.delegate?.loadingFinished()
            case .failure(let error):
                print(error)
                
            default:
                break
            }
        }
    }
}
