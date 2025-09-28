//
//  GlobalActionMiddleware.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

extension Redux {
    static func globalActionMiddleware<S: Redux.State>(globalStore: Redux.GlobalStore) -> Redux.Middleware<S> {
        return { store, action in
            if let globalAction = action as? Redux.GlobalAction {
                await globalStore.dispatch(globalAction)
                return nil
            }
            return action
        }
    }
}
