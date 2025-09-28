//
//  debugDelayRequestMiddleware.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/08.
//

extension Redux {
    static func debugDelayRequestMiddleware<S: Redux.State>() -> Middleware<S> {
        return { store, action in
            if let _ = action as? Redux.ThunkAction<S> {
                try? await Task.sleep(for: .seconds(1))
            }
            return action
        }
    }
}
