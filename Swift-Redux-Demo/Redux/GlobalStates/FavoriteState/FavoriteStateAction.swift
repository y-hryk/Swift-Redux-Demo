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

struct FavoriteStateActionCreator<State: Redux.State> {
    @Injected(\.favoriteRepository) private var favoriteRepository: FavoriteRepository
    
    func getFavorites() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let favorites = try await favoriteRepository.getFavorites()
                return FaroriteStateAction.didReceiveFavorites(.data(value: favorites))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func addFavorite(movie: MovieDetail) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let newer = try await favoriteRepository.addFavorite(movie: movie)
                return FaroriteStateAction.didReceiveFavorites(.data(value: newer))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func removeFavorite(movie: MovieDetail) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let newer = try await favoriteRepository.removeFavorite(movie: movie)
                return FaroriteStateAction.didReceiveFavorites(.data(value: newer))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
