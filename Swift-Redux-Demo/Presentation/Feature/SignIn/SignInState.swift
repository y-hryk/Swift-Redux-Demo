//
//  SignInState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

struct SignInState: Redux.State {
    var userName: String
    var password: String
    var showProgress: Bool
    var progress: Float
}

extension SignInState {
    init() {
        userName = "y-hryk"
        password = "test"
        showProgress = false
        progress = 0.0
    }
    
    static func preview() -> SignInState {
        SignInState(userName: "",
                        password: "",
                        showProgress: false,
                        progress: 0.0)
    }
}

extension SignInState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case SignInStateAction.progressUpdated(let progress):
            state.progress = progress
        case SignInStateAction.progressShown(let progressShown):
            state.showProgress = progressShown
            if progressShown { state.progress = 0.0 }
        case SignInStateAction.userNameUpdated(let userName):
            state.userName = userName
        case SignInStateAction.passwordUpdated(let password):
            state.password = password
        default: break
        }
        return state
    }
}
