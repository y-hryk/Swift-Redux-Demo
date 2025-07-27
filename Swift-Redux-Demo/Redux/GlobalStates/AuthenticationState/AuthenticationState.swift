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
}

extension AuthenticationState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case AuthenticationStateAction.changeAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
        case AuthenticationStateAction.signOutStart:
            state.shouldLogoutTriger = true
        default: break
        }
        return state
    }
}
