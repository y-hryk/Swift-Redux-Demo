//
//  FavoriteState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/20.
//

struct FavoriteState: Redux.State, Equatable {
    var favoriteItems: AsyncValue<[MovieDetail]>
    
    func isFavorite(movieId: MovieId) -> AsyncValue<Bool> {
        guard let favoriteItems = favoriteItems.value else { return .loading }
        return AsyncValue.data(value: favoriteItems.contains { $0.id == movieId })
    }
}

extension FavoriteState {
    init() {
        favoriteItems = .loading
    }
}

extension FavoriteState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case FaroriteStateAction.didReceiveFavorites(let movies):
            state.favoriteItems = movies
        default: break
        }
        return state
    }
}
