//
//  MovieDetailStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import Foundation

extension MovieDetailState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case MovieDetailStateAction.didReceiveMovieDetail(let detail):
            state.movie = detail
        case MovieDetailStateAction.didReceiveBackdrops(let backdrops):
            state.backdrops = backdrops
        case MovieDetailStateAction.didReceiveCreditList(let creditList):
            state.creditList = creditList
        case MovieDetailStateAction.didReceiveReviews(let reviews):
            state.reviews = reviews
        case MovieDetailStateAction.didReceiveIsFavorite(let isFavorite):
            state.isFavorite = isFavorite
        case MovieDetailStateAction.addFavorite:
            state.isFavorite = .data(value: true)
        case MovieDetailStateAction.removeFavorite:
            state.isFavorite = .data(value: false)
            
        default: break
        }
        return state
    }
}
