//
//  GlobalStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

import SwiftUI

extension Redux {
    actor GlobalStore: ObservableObject {
        @MainActor @Published private(set) var state: ApplicationState
        nonisolated private let reducer: Redux.Reducer<ApplicationState>
        nonisolated private let afterMiddleware: Redux.AfterMiddleware<ApplicationState>?
        
        init(
            initialState: ApplicationState = ApplicationState(),
            reducer: @escaping Redux.Reducer<ApplicationState>,
            afterMiddleware: Redux.AfterMiddleware<ApplicationState>?
        ) {
            self._state = Published(wrappedValue: initialState)
            self.reducer = reducer
            self.afterMiddleware = afterMiddleware
        }
        
        func dispatch(_ action: Redux.GlobalAction) async {
            await MainActor.run {
                let currentState = state
                let newState = reducer(currentState, action)
                afterMiddleware?(currentState, newState, action, action)
                state = newState
            }
        }
    }
}
