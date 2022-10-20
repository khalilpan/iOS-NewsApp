//
//  Article.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation

struct Article: Codable {
    let source: Source
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
