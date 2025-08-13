//
//  MovieDetailState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import Foundation

struct MovieDetailState: Redux.State, Equatable {
    var movieId: MovieId
    var movie: AsyncValue<MovieDetail>
    var backdrops: AsyncValue<[Backdrop]>
    var creditList: AsyncValue<CreditList>
    var reviews: AsyncValue<ReviewList>
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
    }
    
    static func fromId(movieId: MovieId) -> MovieDetailState {
        MovieDetailState(
            movieId: movieId,
            movie: .loading,
            backdrops: .loading,
            creditList: .loading,
            reviews: .loading
        )
    }
    
    static func preview() -> Self {
        let movieDetail = MovieDetail.preview()
    
        return MovieDetailState(
            movieId: movieDetail.id,
            movie: .data(value: movieDetail),
            backdrops: .data(value: Backdrop.preview()),
            creditList: .data(value: CreditList.preview()),
            reviews: .loading
        )
    }
}

extension MovieDetailState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case MovieDetailStateAction.movieDetailReceived(let detail):
            state.movie = detail
        case MovieDetailStateAction.didReceiveBackdrops(let backdrops):
            state.backdrops = backdrops
        case MovieDetailStateAction.didReceiveCreditList(let creditList):
            state.creditList = creditList
        case MovieDetailStateAction.didReceiveReviews(let reviews):
            state.reviews = reviews
        default: break
        }
        return state
    }
}
