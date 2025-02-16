//
//  WebApiErrorHandleMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/20.
//

import Foundation

func webApiErrorHandleMiddleware<S: ApplicationState>() -> Middleware<S> {
    return { store, state, actionContainer in
        print(">> webApiErrorHandle")
        switch actionContainer.action {
        case GlobalStateAction.didReceiveError(let error):
            if let error = error as? NetworkError {
                switch error {
                case .unauthorized:
                    return AuthenticationStateAction.signOutStart
                case .serviceUnavailable:
                    await store.dispatch(GlobalStateAction.update(startScreen: .maintenance))
                default: break
                }
            }
        default: break
        }
        return actionContainer.baseAction
    }
}
