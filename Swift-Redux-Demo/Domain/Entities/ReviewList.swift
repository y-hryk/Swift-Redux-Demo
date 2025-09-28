//
//  ReviewList.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/27.
//

import UIKit

struct ReviewList: Equatable {
    let currentPage: Int
    let totalPages: Int
    let results: [Review]
    
    var latestReview: Review? {
        results.first
    }
    
    func shouldLoadData() -> Bool {
        currentPage <= totalPages
    }
    
    func nextPage() -> Int {
        currentPage + 1
    }
    
    
}
