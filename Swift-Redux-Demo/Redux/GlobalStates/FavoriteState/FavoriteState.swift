//
//  FavoriteState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/20.
//

struct FavoriteState: Redux.State, Equatable {
    var favoriteItems: [MovieDetail]
    
    func isFavorite(movieId: MovieId) -> Bool {
        favoriteItems.contains { $0.id == movieId }
    }
}

extension FavoriteState {
    init() {
        favoriteItems = []
    }
}

extension FavoriteState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        
        guard let action = action as? FavoriteStateAction else {
            return state
        }
        
        switch action {
        case .movieAddedToFavorites(let movie):
            state.favoriteItems.append(movie)
            
        case .movieRemovedFromFavorites(let movie):
            state.favoriteItems.removeAll { value in
                value.id == movie.id
            }
        }
        return state
    }
}
