//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation
import UIKit

protocol TopHeadlinesFetchDelegate: AnyObject {
    func loadingStarted()
    func loadingFinished()
}

class HomeViewModel {
    var headLines: [HomeTableViewCellType] = []
    var articles: [Article] = []
    weak var delegate: TopHeadlinesFetchDelegate?
    private var completionClosure: ((Result<[Article], Error>) -> Void)? = nil
    private var showLoadingIndicator: Bool = true
    
    init() {
        setupCompletionClosure()
    }
    
    func fetchHealdLines(calltype: NewsArticlesCallType,with query: String?,showLoadingIndicator: Bool = true) {
        self.showLoadingIndicator = showLoadingIndicator
        guard let completionClosure = self.completionClosure else { return }
        
        //TODO: - Create a BusinessModel and use it inside viewModel instead of Accessing directly Repository
        //(Accessing Repository should be just from businessModel)
        NewsApiRepository.sharedInstance.performApiNewsGetCall(callType: calltype,
                                                               with: query,
                                                               completion: completionClosure)
        self.delegate?.loadingFinished()
    }
    
    private func setupCompletionClosure() {
        self.completionClosure = { [weak self] result in
            guard let self = self else { return }
            self.showLoadingIndicator ? self.delegate?.loadingStarted() : nil
            
            switch result {
            case .success(let response):
                self.articles = response
                self.headLines = response.compactMap({ HomeTableViewCellType(
                    title: $0.title ?? "No Title",
                    subtitle: $0.description ?? "No Description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
                })
                
            case .failure(let error):
                print(error)
                //TODO: - Show Design sysytem's error Dialog
            }
            
            self.delegate?.loadingFinished()
        }
    }
}
