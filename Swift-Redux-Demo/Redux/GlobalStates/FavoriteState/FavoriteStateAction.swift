//
//  FavoriteStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/20.
//

enum FaroriteStateAction: Redux.GlobalAction {
    case addFavorite(detail: MovieDetail)
    case removeFavorite(detail: MovieDetail)
}

struct FavoriteStateActionCreator<State: Redux.State> {
    @Injected(\.favoriteRepository) private var favoriteRepository: FavoriteRepository
    
//    func getFavorites() async -> Redux.ThunkAction<State> {
//        Redux.ThunkAction(function: { store, action in
//            do {
//                let favorites = try await favoriteRepository.getFavorites()
//                return FaroriteStateAction.didReceiveFavorites(.data(value: favorites))
//            } catch let error {
//                return GlobalStateAction.didReceiveError(error)
//            }
//        }, className: "\(type(of: self))")
//    }
    
    func addFavorite(movie: MovieDetail) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            return FaroriteStateAction.addFavorite(detail: movie)
        }, className: "\(type(of: self))")
    }
    
    func removeFavorite(movie: MovieDetail) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            return FaroriteStateAction.removeFavorite(detail: movie)
        }, className: "\(type(of: self))")
    }
}
