//
//  MovieListState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import UIKit

struct MovieListState: Redux.State {
    var movieList: AsyncValue<MovieList>
}

extension MovieListState {
    init() {
        movieList = .loading
    }
    
    static func preview() -> MovieListState {
        MovieListState(movieList: .data(value: MovieList.preview()))
    }
}

extension MovieListState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        
        guard let action = action as? MovieListStateAction else {
            return state
        }
        
        switch action {
        case MovieListStateAction.movieListReceived(let movieList):
            state.movieList = movieList
        case MovieListStateAction.moreMoviesListReceived(let movieList):
            let current = state.movieList.value?.results ?? []
            let newer = current + movieList.results
            state.movieList = .data(value: MovieList(currentPage: movieList.currentPage,
                                                     totalPages: movieList.totalPages,
                                                     results: newer))
        }
        return state
    }
}
