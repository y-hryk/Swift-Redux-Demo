//
//  debugDelayRequestMiddleware.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/08.
//

func debugDelayRequestMiddleware<S: ApplicationState>() -> Middleware<S> {
    return { store, state, actionContainer in
        if let _ = actionContainer.baseAction as? ThunkAction<S> {
            try? await Task.sleep(for: .seconds(1))
        }
        return actionContainer.baseAction
    }
}
