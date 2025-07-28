//
//  GlobalState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

enum StartScreen: Equatable {
    case splash
    case signedIn
    case signedOut
    case maintenance
}

struct GlobalState: Redux.State {
    var startScreen: StartScreen
    var authenticationState: AuthenticationState
    var routingState: RoutingState
    var toastState: ToastState
    var favoriteState: FavoriteState
    var showIndicator: Bool
}

extension GlobalState {
    init() {
        startScreen = .splash
        authenticationState = AuthenticationState()
        routingState = RoutingState()
        toastState = ToastState()
        favoriteState = FavoriteState()
        showIndicator = false
    }
}

extension GlobalState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case GlobalStateAction.update(let startScreen):
            state.startScreen = startScreen
            if startScreen == .splash {
                return GlobalState(
                    startScreen: state.startScreen,
                    authenticationState: AuthenticationState(),
                    routingState: RoutingState(),
                    toastState: ToastState(),
                    favoriteState: FavoriteState(),
                    showIndicator: false
                )
            }
        case GlobalStateAction.showIndicator(let isVisible):
            state.showIndicator = isVisible
        default: break
        }
        return GlobalState(
            startScreen: state.startScreen,
            authenticationState: AuthenticationState.reducer(state.authenticationState, action),
            routingState: RoutingState.reducer(state.routingState, action),
            toastState: ToastState.reducer(state.toastState, action),
            favoriteState: FavoriteState.reducer(state.favoriteState, action),
            showIndicator: state.showIndicator
        )
    }
}
