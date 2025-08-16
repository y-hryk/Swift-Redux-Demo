//
//  SignInState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

struct SignInPageState: Redux.State {
    var userName: String
    var password: String
    var showProgress: Bool
    var progress: Float
}

extension SignInPageState {
    init() {
        userName = "y-hryk"
        password = "test"
        showProgress = false
        progress = 0.0
    }
    
    static func preview() -> SignInPageState {
        SignInPageState(userName: "",
                        password: "",
                        showProgress: false,
                        progress: 0.0)
    }
}

extension SignInPageState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case SignInPageStateAction.progressUpdated(let progress):
            state.progress = progress
        case SignInPageStateAction.progressShown(let progressShown):
            state.showProgress = progressShown
            if progressShown { state.progress = 0.0 }
        case SignInPageStateAction.userNameUpdated(let userName):
            state.userName = userName
        case SignInPageStateAction.passwordUpdated(let password):
            state.password = password
        default: break
        }
        return state
    }
}
