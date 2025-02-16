//
//  MovieDetailStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import UIKit

enum MovieDetailStateAction: Action {
    case didReceiveMovieDetail(AsyncValue<MovieDetail>)
    case didReceiveBackdrops(AsyncValue<[Backdrop]>)
    case didReceiveCreditList(AsyncValue<CreditList>)
    case didReceiveReviews(AsyncValue<ReviewList>)
    case didReceiveIsFavorite(AsyncValue<Bool>)
    case addFavorite(MovieDetail)
    case removeFavorite(MovieDetail)
}

struct MovieDetailStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let movieRepository: MovieRepository
        let favoriteRepository: FavoriteRepository
        let movieId: MovieId
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getMovieDetail() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let movieDetail = try await dependency.movieRepository.getMovieDetail(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveMovieDetail(.data(value: movieDetail))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getImages() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let backDrops = try await dependency.movieRepository.getBackdrpos(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveBackdrops(.data(value: backDrops))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getCreditList() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let credits = try await dependency.movieRepository.getCreditList(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveCreditList(.data(value: credits))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getReviews() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let reviews = try await dependency.movieRepository.getReviews(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveReviews(.data(value: reviews))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func isFavorite(movieId: MovieId) async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let isFavorite = try await dependency.favoriteRepository.isFavorite(movieId: movieId)
                return MovieDetailStateAction.didReceiveIsFavorite(.data(value: isFavorite))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func addFavorite(movie: MovieDetail) async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let _ = try await dependency.favoriteRepository.addFavorite(movie: movie)
                return MovieDetailStateAction.addFavorite(movie)
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func removeFavorite(movie: MovieDetail) async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let newer = try await dependency.favoriteRepository.removeFavorite(movie: movie)
                return MovieDetailStateAction.removeFavorite(newer)
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
