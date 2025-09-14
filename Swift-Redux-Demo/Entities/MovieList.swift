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
        !results.isEmpty && currentPage <= totalPages
    }
    
    func nextPage() -> Int {
        currentPage + 1
    }
    
    static func preview() -> MovieList {
        MovieList(currentPage: 1, totalPages: 1, results: [
            Movie.preview(),
            Movie(id: MovieId(value: "2"),
                  title: "Inside Out 2",
                  overview: " listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
                  rate: UserScore(value: 0),
                  reviewersCount: 1,
                  backdropPath: "/stKGOm8UyhuLPR9sZLjs5AkmncA.jpg",
                  posterPath: "mvRqW2z4iBws3CDkCNmojksyr4V.jpg",
                  releaseDateAt: "2024-07-24"),
            Movie(id: MovieId(value: "3"),
                  title: "Twisters",
                  overview: " listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
                  rate: UserScore(value: 0),
                  reviewersCount: 1,
                  backdropPath: "/58D6ZAvOKxlHjyX9S8qNKSBE9Y.jpg",
                  posterPath: "mvRqW2z4iBws3CDkCNmojksyr4V.jpg",
                  releaseDateAt: "2024-07-24"),
        ])
    }
}

extension MovieList: Equatable {
    static func == (lhs: MovieList, rhs: MovieList) -> Bool {
          return lhs.currentPage == rhs.currentPage &&
                 lhs.totalPages == rhs.totalPages &&
                 lhs.results == rhs.results
    }
}
