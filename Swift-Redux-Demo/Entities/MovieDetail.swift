//
//  MovieDetail.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/22.
//

import Foundation
import SwiftUI

struct MovieDetail: Identifiable, Hashable {
    let id: MovieId
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let rate: UserScore
    let reviewersCount: Int
    let backdropPath: String
    let posterPath: String
    let releaseDateAt: String
    let genres: [Genre]
    let tagline: String
    let runtime: Int
    
    var backdropUrl: String {
        "http://image.tmdb.org/t/p/w1280\(backdropPath)"
    }
    
    var posterUrl: String {
        "http://image.tmdb.org/t/p/w780\(posterPath)"
    }

    var posterImageAspectRatio: CGFloat {
        780 / 1112
    }
    
    var screeningTime: String {
        let hour = runtime / 60
        let min = runtime - (hour * 60)
        return "\(hour)h \(min)min"
    }
    
    var year: String {
        releaseDateAt.split(separator: "-").first?.description ?? ""
    }
    
    static func demos() -> MovieDetail {
        MovieDetail(id: MovieId(value: "1"),
                    title: "aaaaaaaaaaaaaaa",
                    originalTitle: "aaaaaaaaaa",
                    originalLanguage: "en",
                    overview: "Long ago, the Dark Lord Sauron forged a single ring imbued with the power to destroy the world. In Middle-earth, a lone hero severed Sauron's finger, saving the land from his evil dominion. Thousands of years passed, and in the Third Age of Middle-earth, the ring came into the possession of a young hobbit named Frodo. However, Sauron's servants pursued the ring, determined to reclaim it. To protect the world, the ring must be cast into the fires of Mount Orodruin, known as the \"Cracks of Doom,\" and destroyed. Thus, a fellowship of nine companions, led by Frodo, was formed, setting out on a perilous journey to the \"Cracks of Doom\" in a quest to save the world.",
                    rate: UserScore(value: 0.0),
                    reviewersCount: 1,
                    backdropPath: "",
                    posterPath: "",
                    releaseDateAt: "yyyymmdd",
                    genres: [],
                    tagline: "",
                    runtime: 120)
    }
}

extension MovieDetail: Equatable {
    static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        lhs.id == rhs.id
    }
}
