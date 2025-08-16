//
//  LocalStoreBuilder.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

import SwiftUI

struct EmptyState: Redux.State {

}

extension EmptyState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
    
    static func preview() -> EmptyState {
        return .init()
    }
}

enum EmptyStateAction: Redux.Action {
    case processingComplete
}

struct LocalStoreBuilder {
    private init() {}
    
    static func create<State: Redux.State>(
        initialState: State,
        reducer: @escaping Redux.Reducer<State>,
        middleware: [Redux.Middleware<State>] = []
    ) -> Redux.LocalStore<State> {
        Redux.LocalStore(
            initialState: initialState,
            reducer: reducer,
            middleware: [
                Redux.thunkMiddleware(),
                Redux.errorToastMiddleware(),
                Redux.webApiErrorHandleMiddleware(),
                Redux.globalActionMiddleware(globalStore: globalStore)
            ],
            afterMiddleware: Redux.traceAfterMiddleware()
        )
    }
    
    static func createEmpty() -> Redux.LocalStore<EmptyState> {
        Redux.LocalStore<EmptyState>(
            initialState: EmptyState(),
            reducer: { state, action in state },
            middleware: [],
            afterMiddleware: nil
        )
    }
    
    static func stub<State: Redux.State>(state: State) -> Redux.LocalStore<State> {
        Redux.LocalStore<State>(
            initialState: state,
            reducer: { state, action in state },
            middleware: [],
            afterMiddleware: nil
        )
    }
}
