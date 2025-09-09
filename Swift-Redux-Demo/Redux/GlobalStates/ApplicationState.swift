//
//  ApplicationState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/04.
//

import SwiftUI

//enum StartScreen: Equatable {
//    case splash
//    case signedIn
//    case signedOut
//    case maintenance
//}
//
//struct ApplicationState: Redux.State {
//    var startScreen: StartScreen
//    var authenticationState: AuthenticationState
//    var routingState: RoutingState
//    var toastState: ToastState
//    var favoriteState: FavoriteState
//    var deepLinkState: DeepLinkState
//    var showIndicator: Bool
//}
//
//extension ApplicationState {
//    init() {
//        startScreen = .splash
//        authenticationState = AuthenticationState()
//        routingState = RoutingState()
//        toastState = ToastState()
//        favoriteState = FavoriteState()
//        deepLinkState = DeepLinkState()
//        showIndicator = false
//    }
//    
//    static func preview() -> GlobalState {
//        ApplicationState(
//            startScreen: .splash,
//            authenticationState: AuthenticationState.preview(),
//            routingState: RoutingState.preview(),
//            toastState: ToastState.preview(),
//            favoriteState: FavoriteState.preview(),
//            deepLinkState: DeepLinkState.preview(),
//            showIndicator: false
//        )
//    }
//}
//
//extension ApplicationState {
//    static let reducer: Redux.Reducer<Self> = { state, action in
//        var state = state
//        switch action {
//        case ApplicationAction.startScreenChanged(let startScreen):
//            state.startScreen = startScreen
//            if startScreen == .splash {
//                return GlobalState(
//                    startScreen: state.startScreen,
//                    authenticationState: AuthenticationState(),
//                    routingState: RoutingState(),
//                    toastState: ToastState(),
//                    favoriteState: state.favoriteState,
//                    deepLinkState: DeepLinkState(),
//                    showIndicator: false
//                )
//            }
//        case ApplicationAction.indicatorShown(let isVisible):
//            state.showIndicator = isVisible
//        default: break
//        }
//        return ApplicationState(
//            startScreen: state.startScreen,
//            authenticationState: AuthenticationState.reducer(state.authenticationState, action),
//            routingState: RoutingState.reducer(state.routingState, action),
//            toastState: ToastState.reducer(state.toastState, action),
//            favoriteState: FavoriteState.reducer(state.favoriteState, action),
//            deepLinkState: DeepLinkState.reducer(state.deepLinkState, action),
//            showIndicator: state.showIndicator
//        )
//    }
//}
