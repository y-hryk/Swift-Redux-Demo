//
//  GlobalStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

import SwiftUI

extension Redux {
    actor GlobalStore: ObservableObject {
        @MainActor @Published private(set) var state: GlobalState
        nonisolated private let reducer: Redux.Reducer<GlobalState>
        nonisolated private let afterMiddleware: Redux.AfterMiddleware<GlobalState>?
        
        init(
            initialState: GlobalState = GlobalState(),
            reducer: @escaping Redux.Reducer<GlobalState>,
            afterMiddleware: Redux.AfterMiddleware<GlobalState>?
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
