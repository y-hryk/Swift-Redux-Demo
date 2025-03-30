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
            let difference = state.movieListPaths.filter { !paths.contains($0) }
            state.movieListPaths = paths
            difference.forEach { path in
                state.movieNavigationCache.removeValue(forKey: path.initilState().stateIdentifier)
            }
        case RoutingStateAction.showFromMovieList(let navigation):
            state.movieListPaths.append(navigation)
            if state.movieNavigationCache[navigation.initilState().stateIdentifier]  == nil {
                state.movieNavigationCache[navigation.initilState().stateIdentifier] = navigation.initilState()
            }
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
                print("該当なし \(actionContainer)")
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
