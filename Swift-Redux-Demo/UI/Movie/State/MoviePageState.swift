//
//  MovieListState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import UIKit

struct MoviePageState: Redux.State {
    var movieList: AsyncValue<MovieList>
    var presentedUserSetting: Bool
}

extension MoviePageState {
    init() {
        movieList = .loading
        presentedUserSetting = false
    }
}

extension MoviePageState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case MoviePageStateAction.movieListReceived(let movieList):
            state.movieList = movieList
        case MoviePageStateAction.moreMoviesListReceived(let movieList):
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
