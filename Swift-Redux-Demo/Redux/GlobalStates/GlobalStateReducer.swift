//
//  GlobalStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import Foundation

extension GlobalState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case GlobalStateAction.update(let startScreen):
            state.startScreen = startScreen
        default: break
        }
        return GlobalState(
            startScreen: state.startScreen,
            authenticationState: AuthenticationState.reducer(state.authenticationState, actionContainer)
        )
    }
}
