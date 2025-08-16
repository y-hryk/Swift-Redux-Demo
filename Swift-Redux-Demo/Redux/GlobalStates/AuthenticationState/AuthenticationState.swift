//
//  AuthenticationState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/18.
//

import Foundation

struct AuthenticationState: Redux.State, Equatable {
    var isAuthenticated: Bool
    var shouldLogoutTriger = false
}

extension AuthenticationState {
    init() {
        isAuthenticated = false
        shouldLogoutTriger = false
    }
    
    static func preview() -> AuthenticationState {
        AuthenticationState(
            isAuthenticated: false,
            shouldLogoutTriger: false
        )
    }
}

extension AuthenticationState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        
        guard let action = action as? AuthenticationStateAction else { return state }
        
        switch action {
        case .authStateUpdated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
        case .signOutStarted:
            state.shouldLogoutTriger = true
        }
        return state
    }
}
