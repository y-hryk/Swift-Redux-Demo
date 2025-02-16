//
//  MovieDetailState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import Foundation

struct MovieDetailState: ApplicationState {
    var movieId: MovieId
    var movie: AsyncValue<MovieDetail>
    var backdrops: AsyncValue<[Backdrop]>
    var creditList: AsyncValue<CreditList>
    var reviews: AsyncValue<ReviewList>
    var isFavorite: AsyncValue<Bool>
    
    init(movieId: MovieId) {
        self.movieId = movieId
        self.movie = .loading
        self.backdrops = .loading
        self.creditList = .loading
        self.reviews = .loading
        self.isFavorite = .loading
    }
}

extension MovieDetailState: Hashable {
    static func == (lhs: MovieDetailState, rhs: MovieDetailState) -> Bool {
        lhs.movieId.value == rhs.movieId.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieId)
    }
    
    var stateIdentifier: String {
        movieId.value
    }
}

extension MovieDetailState {
    init() {
        self.movieId = MovieId(value: 0)
        self.movie = .loading
        self.backdrops = .loading
        self.creditList = .loading
        self.reviews = .loading
        self.isFavorite = .loading
    }
}
