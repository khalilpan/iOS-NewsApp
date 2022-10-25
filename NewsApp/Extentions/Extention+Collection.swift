//
//  Extention+Collection.swift
//  NewsApp
//
//  Created by khalil on 25/10/22.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
