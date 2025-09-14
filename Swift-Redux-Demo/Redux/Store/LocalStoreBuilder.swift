//
//  LocalStoreBuilder.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

import SwiftUI

// MARK: - LocalStoreBuilder with Builder Pattern
struct LocalStoreBuilder<State: Redux.State> {
    private let initialState: State
    private let reducer: Redux.Reducer<State>
    private var customMiddleware: [Redux.Middleware<State>] = []
    private var isTraceEnabled: Bool = false
    private var isDelayRequestEnabled: Bool = false
    
    private init(initialState: State, reducer: @escaping Redux.Reducer<State>) {
        self.initialState = initialState
        self.reducer = reducer
    }
    
    // MARK: - Factory Methods
    static func create(
        initialState: State,
        reducer: @escaping Redux.Reducer<State>
    ) -> LocalStoreBuilder<State> {
        return LocalStoreBuilder(initialState: initialState, reducer: reducer)
    }
    
    static func `default`(
        initialState: State
    ) -> LocalStoreBuilder<State> {
        LocalStoreBuilder(
            initialState: initialState,
            reducer: State.reducer
        )
        .withMiddleware([
            Redux.thunkMiddleware(),
            Redux.errorToastMiddleware(),
            Redux.webApiErrorHandleMiddleware(),
            Redux.globalActionMiddleware(globalStore: globalStore)
        ])
        .enableTrace()
    }
    
    static func stub(state: State) -> LocalStoreBuilder<State> {
        LocalStoreBuilder(
            initialState: state,
            reducer: { state, action in state }
        )
    }
    
    // MARK: - Builder Methods
    func withMiddleware(_ middleware: @escaping Redux.Middleware<State>) -> LocalStoreBuilder<State> {
        var builder = self
        builder.customMiddleware.append(middleware)
        return builder
    }
    
    func withMiddleware(_ middleware: [Redux.Middleware<State>]) -> LocalStoreBuilder<State> {
        var builder = self
        builder.customMiddleware.append(contentsOf: middleware)
        return builder
    }

    func enableTrace() -> LocalStoreBuilder<State> {
        var builder = self
        builder.isTraceEnabled = true
        return builder
    }
    
    func enableDelayRequest() -> LocalStoreBuilder<State> {
        var builder = self
        builder.isDelayRequestEnabled = true
        return builder
    }
    
    // MARK: - Build Method
    func build() -> Redux.LocalStore<State> {
        Redux.LocalStore(
            initialState: initialState,
            reducer: reducer,
            middleware: isDelayRequestEnabled ? [Redux.debugDelayRequestMiddleware()] + customMiddleware : customMiddleware,
            isTraceEnabled: isTraceEnabled
        )
    }
}

// MARK: - Usage Examples
/*
// Basic usage with default middleware
let store = LocalStoreBuilder
    .create(initialState: AppState(), reducer: appReducer)
    .build()

// Custom middleware configuration
let customStore = LocalStoreBuilder
    .create(initialState: AppState(), reducer: appReducer)
    .withoutDefaultMiddleware()
    .withThunk()
    .withErrorToast()
    .withMiddleware(customLoggingMiddleware)
    .withTrace()
    .build()

// Stub for testing
let testStore = LocalStoreBuilder
    .stub(state: AppState.testState)
    .build()

// Empty store
let emptyStore = LocalStoreBuilder<EmptyState>
    .createEmpty()
    .build()

// Advanced configuration
let advancedStore = LocalStoreBuilder
    .create(initialState: FeatureState(), reducer: featureReducer)
    .withMiddleware([
        customMiddleware1,
        customMiddleware2
    ])
    .withAfterMiddleware(customAfterMiddleware)
    .build()
*/
