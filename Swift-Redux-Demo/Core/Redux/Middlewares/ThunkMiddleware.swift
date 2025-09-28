//
//  ThunkMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/15.
//

import Foundation

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
