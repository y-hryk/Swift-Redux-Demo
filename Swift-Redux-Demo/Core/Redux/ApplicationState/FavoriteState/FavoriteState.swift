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
    
    static func preview() -> FavoriteState {
        FavoriteState(favoriteItems: [
            MovieDetail(id: MovieId(value: "1891"),
                        title: "スター・ウォーズ エピソード５／帝国の逆襲",
                        originalTitle: "originalTitle",
                        originalLanguage: "en",
                        overview: "",
                        rate: UserScore(value: 8.4),
                        reviewersCount: 17596,
                        backdropPath: "/kgjvZgs6cV2v5bigzzzWqJ9EMGs.jpg",
                        posterPath: "/mbLTbU4zqdY1nOQP9OTxj9LeRTL.jpg",
                        releaseDateAt: "1980-05-20",
                        genres: [],
                        tagline: "",
                        runtime: 120)
        ])
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
