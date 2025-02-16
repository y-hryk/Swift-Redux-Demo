//
//  HomeStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import Foundation

extension MoviePageState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case MoviePageStateAction.didReceiveMovieList(let movieList):
            state.movieList = movieList
        case MoviePageStateAction.didMoreReceiveMovieList(let movieList):
            let current = state.movieList.value?.results ?? []
            let newer = current + movieList.results
            state.movieList = .data(value: MovieList(currentPage: movieList.currentPage,
                                                     totalPages: movieList.totalPages,
                                                     results: newer))
        default: break
        }
        return state
    }
}
