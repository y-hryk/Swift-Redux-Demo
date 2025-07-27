//
//  MovieDetailStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import UIKit

enum MovieDetailStateAction: Redux.Action {
    case didReceiveMovieDetail(AsyncValue<MovieDetail>)
    case didReceiveBackdrops(AsyncValue<[Backdrop]>)
    case didReceiveCreditList(AsyncValue<CreditList>)
    case didReceiveReviews(AsyncValue<ReviewList>)
}

struct MovieDetailStateActionCreator<S: Redux.State>: Injectable {
    struct Dependency {
        let movieRepository: MovieRepository
        let favoriteRepository: FavoriteRepository
        let movieId: MovieId
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getMovieDetail() async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let movieDetail = try await dependency.movieRepository.getMovieDetail(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveMovieDetail(.data(value: movieDetail)
                )
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getImages() async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let backDrops = try await dependency.movieRepository.getBackdrpos(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveBackdrops(.data(value: backDrops))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getCreditList() async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let credits = try await dependency.movieRepository.getCreditList(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveCreditList(.data(value: credits))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getReviews() async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let reviews = try await dependency.movieRepository.getReviews(movieId: dependency.movieId)
                return MovieDetailStateAction.didReceiveReviews(.data(value: reviews))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
