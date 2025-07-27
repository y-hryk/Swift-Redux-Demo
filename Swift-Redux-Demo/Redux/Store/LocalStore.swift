//
//  ViewStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

import SwiftUI

extension Redux {
    actor LocalStore<State: Redux.State>: ObservableObject {
        @MainActor @Published private(set) var state: State
        nonisolated private let reducer: Redux.Reducer<State>
        private let middleware: [Redux.Middleware<State>]
        nonisolated private let afterMiddleware: Redux.AfterMiddleware<State>?

        deinit {
            print("\(type(of: state)) deinit")
        }
        
        init(
            initialState: State,
            reducer: @escaping Redux.Reducer<State>,
            middleware: [Redux.Middleware<State>],
            afterMiddleware: Redux.AfterMiddleware<State>?
        ) {
            self.reducer = reducer
            self.middleware = middleware
            self.afterMiddleware = afterMiddleware
            self._state = Published(wrappedValue: initialState)
            print("\(type(of: initialState)) init")
        }
        
        func dispatch(_ action: Redux.Action) async {
            var currentAction: Redux.Action? = action
            for m in middleware {
                if let action = currentAction {
                    currentAction = await m(self, action)
                }
            }
            
            guard let newAction = currentAction else { return }
            
            await MainActor.run {
                let currentState = state
                let newState = reducer(currentState, newAction)
                afterMiddleware?(currentState,
                                 newState,
                                 action,
                                 newAction)
                state = newState
            }
        }
    }
}
