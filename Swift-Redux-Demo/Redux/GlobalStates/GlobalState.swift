//
//  GlobalState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

enum StartScreen: Equatable {
    case splash
    case root
    case onboarding
    case maintenance
}

struct GlobalState: ApplicationState {
    var startScreen: StartScreen
    var authenticationState: AuthenticationState
}

extension GlobalState {
    init() {
        startScreen = .splash
        authenticationState = AuthenticationState()
    }
}
