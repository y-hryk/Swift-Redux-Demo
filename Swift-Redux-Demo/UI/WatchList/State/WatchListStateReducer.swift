import Foundation

extension WatchListPageState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        // MovieDetailStateAction
        case MovieDetailStateAction.addFavorite(let movie):
            switch state.movies {
            case .data(value: let movies):
                var movies = movies
                if !movies.contains(movie) {
                    movies.append(movie)
                    state.movies = .data(value: movies)
                }
            default: break
            }
        case MovieDetailStateAction.removeFavorite(let movie):
            switch state.movies {
            case .data(value: let movies):
                var movies = movies
                movies.removeAll { $0.id == movie.id }
                state.movies = .data(value: movies)
            default: break
            }
        case WatchListStateAction.didReceiveFavorites(let movies):
            state.movies = movies
        default: break
        }
        return state
    }
}
