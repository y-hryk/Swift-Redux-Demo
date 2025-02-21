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
        case RoutingStateAction.setInitialState(let initialState):
            state.movieNavigationCache[initialState.stateIdentifier] = initialState
        default: break
        }
        
        if let mapAction = actionContainer.mapAction() {
            if let mapState = state.movieNavigationCache[mapAction.id] {
                state.movieNavigationCache = state.movieNavigationCache.mapValues {
                    if mapState.stateIdentifier != $0.stateIdentifier && mapState.className == $0.className {
                        return $0
                    }
                    return $0.reducer(state: $0, actionContainer: actionContainer)
                }
            } else {
                fatalError("更新対象のStateが設定されていません (\(actionContainer.caller)")
            }
        } else {
            state.movieNavigationCache = state.movieNavigationCache.mapValues {
                return $0.reducer(state: $0, actionContainer: actionContainer)
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
