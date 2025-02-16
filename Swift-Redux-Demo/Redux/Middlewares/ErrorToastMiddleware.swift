//
//  ErrorToastMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/20.
//

import Foundation

//extension Middlewares {
//    static let errorToast: Middleware<AppState> = { store, state, actionContainer in
//        switch actionContainer.action {
//        case GlobalStateAction.didReceiveError(let error):
//            if let error = error as? ApplicationError {
//                await store.dispatch(GlobalStateAction.didReceiveToast(
//                    Toast(style: .error, title: error.title, message: error.message)
//                ))
//                return actionContainer.baseAction
//            } else {
//                await store.dispatch(GlobalStateAction.didReceiveToast(
//                    Toast(style: .error, message: error.localizedDescription)
//                ))
//                return actionContainer.baseAction
//            }
//        default: break
//        }
//        return actionContainer.baseAction
//    }
//}

func errorToastMiddleware<S: ApplicationState>() -> Middleware<S> {
    return { store, state, actionContainer in
        switch actionContainer.action {
        case GlobalStateAction.didReceiveError(let error):
            if let error = error as? ApplicationError {
                await store.dispatch(ToastStateAction.didReceiveToast(
                    Toast(style: .error, title: error.title, message: error.message)
                ))
                return actionContainer.baseAction
            } else {
                await store.dispatch(ToastStateAction.didReceiveToast(
                    Toast(style: .error, message: error.localizedDescription)
                ))
                return actionContainer.baseAction
            }
        default: break
        }
        return actionContainer.baseAction
    }
}
