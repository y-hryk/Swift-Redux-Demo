//
//  RoutingStateReduver.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

extension RoutingState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case RoutingStateAction.updateMovieList(let paths):
            state.movieListPaths = paths
        case RoutingStateAction.showFromMovieList(let navigation):
            state.movieListPaths.append(navigation)
        default: break
        }
        
        state.movieListPaths = state.movieListPaths.map {
            switch $0 {
            case .movieDetail(let state):
                return NavigationStackPath.movieDetail(
                    state: MovieDetailState.reducer(state, actionContainer)
                )
            }
        }

        return RoutingState(
            tabState: TabState.reducer(state.tabState, actionContainer),
            signInPageState: SignInPageState.reducer(state.signInPageState, actionContainer),
            movieListPaths: state.movieListPaths,
            movieNavigationCache: state.movieNavigationCache
        )
    }
}
