//
//  HomeAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import Foundation

enum MovieListStateAction: Redux.Action {
    case movieListReceived(AsyncValue<MovieList>)
    case moreMoviesListReceived(MovieList)
}

struct MovieListStateActionCreator<State: Redux.State> {
    @Injected(\.movieRepository) private var movieRepository: MovieRepository
    
    func movieListRequested() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let movieList = try await movieRepository.getMovieTopRated(page: nil)
                return MovieListStateAction.movieListReceived(.data(value: movieList))
            } catch let error {
                await store.dispatch(ApplicationAction.errorReceived(error))
                return MovieListStateAction.movieListReceived(.error(error: error))
            }
        }, className: "\(type(of: self))")
    }
    
    func movieListMoreRequested(movieList: MovieList) async -> Redux.ThunkAction<State> {
        return Redux.ThunkAction(function: { store, action in
            if !movieList.shouldLoadData() { return nil }
            do {
                let nextPage = movieList.nextPage()
                let movieList = try await movieRepository.getMovieTopRated(page: nextPage)
                return MovieListStateAction.moreMoviesListReceived(movieList)
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
}
