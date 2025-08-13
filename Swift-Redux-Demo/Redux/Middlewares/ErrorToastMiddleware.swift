//
//  ErrorToastMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/20.
//

import Foundation

extension Redux {
    static func errorToastMiddleware<S: Redux.State>() -> Redux.Middleware<S> {
        return { store, action in
            switch action {
            case GlobalStateAction.errorReceived(let error):
                if let error = error as? ApplicationError {
                    await store.dispatch(ToastStateAction.didReceiveToast(
                        Toast(style: .error, title: error.title, message: error.message)
                    ))
                } else {
                    await store.dispatch(ToastStateAction.didReceiveToast(
                        Toast(style: .error, message: error.localizedDescription)
                    ))
                }
            default: break
            }
            return action
        }
    }
}
