//
//  HomeAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import Foundation

enum MoviePageStateAction: Redux.Action {
    case movieListReceived(AsyncValue<MovieList>)
    case moreMoviesListReceived(MovieList)
}

struct MoviePageStateActionCreator<State: Redux.State> {
    @Injected(\.movieRepository) private var movieRepository: MovieRepository
    
    func movieListRequested() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let movieList = try await movieRepository.getMovieTopRated(page: nil)
                return MoviePageStateAction.movieListReceived(.data(value: movieList))
            } catch let error {
                await store.dispatch(ApplicationAction.errorReceived(error))
                return MoviePageStateAction.movieListReceived(.error(error: error))
            }
        }, className: "\(type(of: self))")
    }
    
    func movieListMoreRequested(movieList: MovieList) async -> Redux.ThunkAction<State> {
        return Redux.ThunkAction(function: { store, action in
            if !movieList.shouldLoadData() { return nil }
            do {
                let nextPage = movieList.nextPage()
                let movieList = try await movieRepository.getMovieTopRated(page: nextPage)
                return MoviePageStateAction.moreMoviesListReceived(movieList)
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
}
