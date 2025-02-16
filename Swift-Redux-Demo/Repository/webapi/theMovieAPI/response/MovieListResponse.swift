//
//  MovieListResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/22.
//

import Foundation

struct MovieListResponse: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
    
    struct Movie: Codable {
        let id: Int
        let title: String
        let overview: String
        let rate: Float
        let reviewersCount: Int
        let backdropPath: String
        let posterPath: String
        let releaseDateAt: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case overview
            case rate = "vote_average"
            case reviewersCount = "vote_count"
            case backdropPath = "backdrop_path"
            case posterPath = "poster_path"
            case releaseDateAt = "release_date"
        }
    }
}
