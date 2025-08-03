//
//  HomeAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import Foundation

enum MoviePageStateAction: Redux.Action {
    case didReceiveMovieList(AsyncValue<MovieList>)
    case didMoreReceiveMovieList(MovieList)
    case shuffleRateScore
}

struct MoviePageStateActionCreator<State: Redux.State> {
    @Injected(\.movieRepository) private var movieRepository: MovieRepository
    
    func getMovies() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let movieList = try await movieRepository.getMovieTopRated(page: nil)
                return MoviePageStateAction.didReceiveMovieList(.data(value: movieList))
            } catch let error {
                await store.dispatch(GlobalStateAction.didReceiveError(error))
                return MoviePageStateAction.didReceiveMovieList(.error(error: error))
            }
        }, className: "\(type(of: self))")
    }
    
    func getMoreMovies(movieList: MovieList) async -> Redux.ThunkAction<State> {
        return Redux.ThunkAction(function: { store, action in
            if !movieList.shouldLoadData() { return nil }
            do {
                let nextPage = movieList.nextPage()
                let movieList = try await movieRepository.getMovieTopRated(page: nextPage)
                return MoviePageStateAction.didMoreReceiveMovieList(movieList)
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
