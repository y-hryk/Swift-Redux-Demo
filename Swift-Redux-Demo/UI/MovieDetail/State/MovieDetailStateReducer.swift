//
//  MovieDetailStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import Foundation


extension MovieDetailState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case MovieDetailStateAction.didReceiveMovieDetail(let detail):
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


/*
extension MovieDetailState {
    static let reducerWithHashMap: ([MovieId: Self], ActionContainer) -> ([MovieId: Self]) = { state, actionContainer in
        var newState = state
        switch actionContainer.action {
        case MovieDetailStateAction.didReceiveMovieDetail(let detail):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.movie = detail
            newState[movieId] = state
        case MovieDetailStateAction.didReceiveBackdrops(let backdrops):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.backdrops = backdrops
            newState[movieId] = state
        case MovieDetailStateAction.didReceiveCreditList(let creditList):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.creditList = creditList
            newState[movieId] = state
        case MovieDetailStateAction.didReceiveReviews(let reviews):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.reviews = reviews
            newState[movieId] = state
        case MovieDetailStateAction.didReceiveIsFavorite(let isFavorite):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.isFavorite = isFavorite
            newState[movieId] = state
        case MovieDetailStateAction.addFavorite(let detail):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.isFavorite = .data(value: true)
            newState[movieId] = state
        case MovieDetailStateAction.removeFavorite(let detail):
            var state = MovieDetailState.mapToState(hashMap: state, id: movieId)
            state.isFavorite = .data(value: false)
            newState[movieId] = state
        default: break
        }
        return newState
    }
    
    static func mapToState(hashMap: [MovieId: MovieDetailState], id: MovieId) -> MovieDetailState {
        hashMap[id] ?? MovieDetailState.fromId(movieId: id)
    }
}
*/
