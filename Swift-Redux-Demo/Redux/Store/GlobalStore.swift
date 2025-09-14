//
//  GlobalStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

import SwiftUI

let globalStore = Redux.GlobalStore(
    reducer: ApplicationState.reducer,
    isTraceEnabled: true
)

// MARK: - Custom Environment Key
struct GlobalStoreKey: EnvironmentKey {
    static let defaultValue: Redux.GlobalStore? = nil
}

extension EnvironmentValues {
    var globalStore: Redux.GlobalStore? {
        get { self[GlobalStoreKey.self] }
        set { self[GlobalStoreKey.self] = newValue }
    }
}

extension Redux {
    actor GlobalStore: ObservableObject {
        @MainActor @Published private(set) var state: ApplicationState
        nonisolated private let reducer: Redux.Reducer<ApplicationState>
        private let isTraceEnabled: Bool
        
        init(
            initialState: ApplicationState = ApplicationState(),
            reducer: @escaping Redux.Reducer<ApplicationState>,
            isTraceEnabled: Bool = false
        ) {
            self._state = Published(wrappedValue: initialState)
            self.reducer = reducer
            self.isTraceEnabled = isTraceEnabled
        }
        
        func dispatch(_ action: Redux.GlobalAction) async {
            await MainActor.run {
                let currentState = state
                let newState = reducer(currentState, action)
                if isTraceEnabled {
                    ActionTracer.trace(before: currentState, after: newState, action: action, newAction: action)
                }
                state = newState
            }
        }
    }
}
