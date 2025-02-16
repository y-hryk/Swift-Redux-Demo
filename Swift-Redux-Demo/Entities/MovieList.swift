//
//  MovieList.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/25.
//

import UIKit

struct MovieList {
    let currentPage: Int
    let totalPages: Int
    let results: [Movie]
    
    func shouldLoadData() -> Bool {
        currentPage <= totalPages
    }
    
    func nextPage() -> Int {
        currentPage + 1
    }
    
    static func demos() -> MovieList {
        MovieList(currentPage: 1, totalPages: 1, results: Movie.demos())
    }
}
