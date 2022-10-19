//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

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
}
