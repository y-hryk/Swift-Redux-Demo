//
//  FavoriteStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/20.
//

enum FaroriteStateAction: Redux.GlobalAction {
    case didReceiveFavorites(AsyncValue<[MovieDetail]>)
    case didReceiveIsFavorite(AsyncValue<Bool>)
    case addFavorite(detail: MovieDetail)
    case removeFavorite(detail: MovieDetail)
}

struct FavoriteStateActionCreator<S: Redux.State>: Injectable {
    struct Dependency {
        let favoriteRepository: FavoriteRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getFavorites() async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let favorites = try await dependency.favoriteRepository.getFavorites()
                return FaroriteStateAction.didReceiveFavorites(.data(value: favorites))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
//    func isFavorite(movieId: MovieId) async -> Redux.ThunkAction<S> {
//        Redux.ThunkAction(function: { store, action in
//            do {
//                let isFavorite = try await dependency.favoriteRepository.isFavorite(movieId: movieId)
//                return FaroriteStateAction.didReceiveIsFavorite(.data(value: isFavorite))
//            } catch let error {
//                return GlobalStateAction.didReceiveError(error)
//            }
//        }, className: "\(type(of: self))")
//    }
    
    func addFavorite(movie: MovieDetail) async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let newer = try await dependency.favoriteRepository.addFavorite(movie: movie)
                return FaroriteStateAction.didReceiveFavorites(.data(value: newer))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func removeFavorite(movie: MovieDetail) async -> Redux.ThunkAction<S> {
        Redux.ThunkAction(function: { store, action in
            do {
                let newer = try await dependency.favoriteRepository.removeFavorite(movie: movie)
                return FaroriteStateAction.didReceiveFavorites(.data(value: newer))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
