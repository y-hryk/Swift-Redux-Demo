//
//  RoutingState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

struct RoutingState: ApplicationState {
    // rootView
    var tabState: TabState
    var signInPageState: SignInPageState
    // NavitionsStacks
    var movieListPaths: [NavigationStackPath]
    var watchListPaths: [NavigationStackPath]
    var movieNavigationCache: [String: any ApplicationState]
    var watchListNavigationCache: [String: any ApplicationState]
    
    func mapStateFromMovieList<State: ApplicationState>(stateIdentifier: String) -> State {
        movieNavigationCache[stateIdentifier] as? State ?? State()
    }
    
    func mapStateFromWatch<State: ApplicationState>(stateIdentifier: String) -> State {
        movieNavigationCache[stateIdentifier] as? State ?? State()
    }
    
    func fixNavitionStackPaths(difference: [NavigationStackPath]) -> [String: any ApplicationState] {
        var cache: [String: any ApplicationState] = movieNavigationCache
        difference.forEach { path in
            if !allNavitionPaths.contains(path) {
                cache.removeValue(forKey: path.initilState().stateIdentifier)
            }
        }
        return cache
    }
    
    private var allNavitionPaths: [NavigationStackPath] {
        movieListPaths + watchListPaths
    }
}

extension RoutingState {
    init() {
        tabState = TabState()
        signInPageState = SignInPageState()
        movieListPaths = []
        watchListPaths = []
        movieNavigationCache = [:]
        watchListNavigationCache = [:]
    }
    
    static func demos() -> any ApplicationState {
        return RoutingState(
            tabState: TabState(),
            signInPageState: SignInPageState(),
            movieListPaths: [],
            watchListPaths: [],
            movieNavigationCache: [
                MovieDetailState.preview().stateIdentifier: MovieDetailState.preview()
            ],
            watchListNavigationCache: [:]
        )
    }
}

class AppEnvironment: ObservableObject {
    @Published var moviePath: [NavigationStackPath] = []
}
