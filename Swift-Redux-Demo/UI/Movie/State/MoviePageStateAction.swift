//
//  HomeAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import Foundation

enum MoviePageStateAction: Action {
    case didReceiveMovieList(AsyncValue<MovieList>)
    case didMoreReceiveMovieList(MovieList)
    case shuffleRateScore
}

struct MoviePageStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let movieRepository: MovieRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getMovies() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let movieList = try await dependency.movieRepository.getMovieTopRated(page: nil)
                return MoviePageStateAction.didReceiveMovieList(.data(value: movieList))
            } catch let error {
                await store.dispatch(GlobalStateAction.didReceiveError(error))
                return MoviePageStateAction.didReceiveMovieList(.error(error: error))
            }
        }, className: "\(type(of: self))")
    }
    
    func getMoreMovies(movieList: MovieList) async -> ThunkAction<S> {
        return ThunkAction(function: { store, action in
            if !movieList.shouldLoadData() { return nil }
            do {
                let nextPage = movieList.nextPage()
                let movieList = try await dependency.movieRepository.getMovieTopRated(page: nextPage)
                return MoviePageStateAction.didMoreReceiveMovieList(movieList)
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
