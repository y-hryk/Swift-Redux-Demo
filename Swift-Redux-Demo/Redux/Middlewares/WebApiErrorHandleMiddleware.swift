//
//  WebApiErrorHandleMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/20.
//

import Foundation

extension Redux {
    static func webApiErrorHandleMiddleware<S: Redux.State>() -> Redux.Middleware<S> {
        return { store, action in
            switch action {
            case GlobalStateAction.errorReceived(let error):
                if let error = error as? NetworkError {
                    switch error {
                    case .unauthorized:
                        return AuthenticationStateAction.signOutStarted
                    case .serviceUnavailable:
                        await store.dispatch(GlobalStateAction.startScreenChanged(startScreen: .maintenance))
                    default: break
                    }
                }
            default: break
            }
            return action
        }
    }
}
