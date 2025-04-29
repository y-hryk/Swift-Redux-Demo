//
//  ThunkMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/15.
//

import Foundation

func thunkMiddleware<S: ApplicationState>() -> Middleware<S> {
    return { store, state, actionContainer in
        if let action = actionContainer.baseAction as? ThunkAction<S> {
            return await action.function(store, action)
        }
        if let mapAction = actionContainer.baseAction as? MapAction,
            let action = mapAction.originalAction as? ThunkAction<S> {
            if let newAction = await action.function(store, action) {
                return MapAction(id: mapAction.id, originalAction: newAction)
            }
            return nil
        }
        return actionContainer.baseAction
    }
}
