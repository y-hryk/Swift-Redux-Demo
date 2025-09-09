//
//  MovieDetailStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import UIKit

enum MovieDetailStateAction: Redux.Action {
    case movieDetailReceived(AsyncValue<MovieDetail>)
    case didReceiveBackdrops(AsyncValue<[Backdrop]>)
    case didReceiveCreditList(AsyncValue<CreditList>)
    case didReceiveReviews(AsyncValue<ReviewList>)
}

struct MovieDetailStateActionCreator<State: Redux.State> {
    @Injected(\.movieRepository) private var movieRepository: MovieRepository
    private let movieId: MovieId
    
    init(movieId: MovieId) {
        self.movieId = movieId
    }
    
    func getMovieDetail() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let movieDetail = try await movieRepository.getMovieDetail(movieId: movieId)
                return MovieDetailStateAction.movieDetailReceived(.data(value: movieDetail)
                )
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getImages() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let backDrops = try await movieRepository.getBackdrpos(movieId: movieId)
                return MovieDetailStateAction.didReceiveBackdrops(.data(value: backDrops))
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getCreditList() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let credits = try await movieRepository.getCreditList(movieId: movieId)
                return MovieDetailStateAction.didReceiveCreditList(.data(value: credits))
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getReviews() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let reviews = try await movieRepository.getReviews(movieId: movieId)
                return MovieDetailStateAction.didReceiveReviews(.data(value: reviews))
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
}
