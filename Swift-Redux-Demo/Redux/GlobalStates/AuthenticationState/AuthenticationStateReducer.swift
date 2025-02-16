//
//  AuthenticationStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/20.
//

import Foundation

extension AuthenticationState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case AuthenticationStateAction.changeAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
        case AuthenticationStateAction.signOutStart:
            state.shouldLogoutTriger = true
        default: break
        }
        return state
    }
}
