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
    var movieNavigationCache: [String: any ApplicationState]
    
    func find<State: ApplicationState>(stateID: String? = nil) -> State {
        let state = movieListPaths.first { path in
            if let stateID = stateID {
                return path.state() is State && path.state().stateIdentifier == stateID
            }
             return path.state() is State
        }?.state() as? State
        return state ?? State()
    }
}

extension RoutingState {
    init() {
        tabState = TabState()
        signInPageState = SignInPageState()
        movieListPaths = []
        movieNavigationCache = [:]
    }
    
}

class AppEnvironment: ObservableObject {
    @Published var moviePath: [NavigationStackPath] = []
}
