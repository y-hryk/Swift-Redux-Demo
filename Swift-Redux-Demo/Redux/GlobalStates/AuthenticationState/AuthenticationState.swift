//
//  AuthenticationState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/18.
//

import Foundation

struct AuthenticationState: ApplicationState {
    var isAuthenticated: Bool
    var shouldLogoutTriger = false
}

extension AuthenticationState {
    init() {
        isAuthenticated = false
        shouldLogoutTriger = false
    }
}
