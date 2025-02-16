//
//  MovieDetailResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/22.
//

import Foundation

struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let rate: Float
    let reviewersCount: Int
    let backdropPath: String
    let posterPath: String
    let releaseDateAt: String
    let genres: [Genres]
    let runtime: Int
    let tagline: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview
        case rate = "vote_average"
        case reviewersCount = "vote_count"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDateAt = "release_date"
        case genres
        case runtime
        case tagline
    }
    
    struct Genres: Codable {
        let id: Int
        let name: String
    }
}
