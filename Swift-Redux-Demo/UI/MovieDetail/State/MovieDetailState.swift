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
}

extension MovieDetailState: Hashable {
    static func == (lhs: MovieDetailState, rhs: MovieDetailState) -> Bool {
        lhs.movieId.value == rhs.movieId.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieId)
    }
}

extension MovieDetailState {
    var stateIdentifier: String {
        className + "_" + movieId.value
    }
    
    init() {
        self.movieId = MovieId(value: 0)
        self.movie = .loading
        self.backdrops = .loading
        self.creditList = .loading
        self.reviews = .loading
        self.isFavorite = .loading
    }
    
    static func fromId(movieId: MovieId) -> MovieDetailState {
        MovieDetailState(
            movieId: movieId,
            movie: .loading,
            backdrops: .loading,
            creditList: .loading,
            reviews: .loading,
            isFavorite: .loading
        )
    }
    
    static func preview() -> Self {
        let movieDetail = MovieDetail.preview()
    
        return MovieDetailState(
            movieId: movieDetail.id,
            movie: .data(value: movieDetail),
            backdrops: .data(value: Backdrop.preview()),
            creditList: .data(value: CreditList.preview()),
            reviews: .loading,
            isFavorite: .data(value: false)
        )
    }
}
