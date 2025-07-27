//
//  ThunkMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/15.
//

import Foundation

//func thunkMiddleware<S: ApplicationState>() -> Middleware<S> {
//    return { store, state, actionContainer in
//        if let action = actionContainer.baseAction as? ThunkAction<S> {
//            if action.isFullScreenLoading {
//                await store.dispatch(GlobalStateAction.updateIndicator(fullScreenIndicatorVisible: true))
//            }
//            let newAction = await action.function(store, action)
//            if action.isFullScreenLoading {
//                await store.dispatch(GlobalStateAction.updateIndicator(fullScreenIndicatorVisible: false))
//            }
//            return newAction
//        }
//        if let mapAction = actionContainer.baseAction as? MapAction,
//            let action = mapAction.originalAction as? ThunkAction<S> {
//            if let newAction = await action.function(store, action) {
//                return MapAction(id: mapAction.id, originalAction: newAction)
//            }
//            return nil
//        }
//        return actionContainer.baseAction
//    }
//}

extension Redux {
    static func thunkMiddleware<S: Redux.State>() -> Redux.Middleware<S> {
        return { store, action in
            if let action = action as? Redux.ThunkAction<S> {
                let newAction = await action.function(store, action)
                return newAction
            }
            return action
        }
    }
}
