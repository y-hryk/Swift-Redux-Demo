//
//  ViewStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

import SwiftUI

extension Redux {
    enum LocalStoreType {
        case normal
        case stub
    }
    actor LocalStore<State: Redux.State>: ObservableObject {
        @MainActor @Published private(set) var state: State
        nonisolated private let reducer: Redux.Reducer<State>
        private let middleware: [Redux.Middleware<State>]
        private let isTraceEnabled: Bool

//        deinit {
//            print("\(type(of: state)) deinit")
//        }
        
        init(
            initialState: State,
            reducer: @escaping Redux.Reducer<State>,
            middleware: [Redux.Middleware<State>],
            isTraceEnabled: Bool = false
        ) {
            self.reducer = reducer
            self.middleware = middleware
            self.isTraceEnabled = isTraceEnabled
            self._state = Published(wrappedValue: initialState)
        }
        
        func dispatch(_ action: Redux.Action) async {
            var currentAction: Redux.Action? = action
            for middlewareFunction in middleware {
                if let action = currentAction {
                    currentAction = await middlewareFunction(self, action)
                }
            }
            
            guard let newAction = currentAction else { return }
            
            await MainActor.run {
                let currentState = state
                let newState = reducer(currentState, newAction)
                if isTraceEnabled {
                    ActionTracer.trace(before: currentState, after: newState, action: action, newAction: newAction)
                }
                state = newState
            }
        }
    }
}
