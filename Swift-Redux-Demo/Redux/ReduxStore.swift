//
//  ReduxStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

struct StateIdentifier: Equatable {
    let value: String
}

protocol ApplicationState {
    init()
    var stateIdentifier: String { get }
    static var reducer: Reducer<Self> { get }
}

extension ApplicationState {
    var stateIdentifier: String {
        UUID().uuidString
    }

    var className: String {
        return String(describing: type(of: self))
    }
    
    func reducer<T: ApplicationState>(state: T, actionContainer: ActionContainer) -> T {
        T.reducer(state, actionContainer)
    }
}

protocol Action {}
protocol BaseMapAction: Action {}


struct ActionContainer {
    let caller: String
    let baseAction: Action // Action or MapAction or ThunkAction
    
    var action: Action {
        if let value = baseAction as? MapAction {
            return value.originalAction
        }
        return baseAction
    }
    
    func mapAction() -> MapAction? {
        if let mapAction = baseAction as? MapAction {
            return mapAction
        }
        return nil
    }
    
    func thunkAction<S: ApplicationState>() -> ThunkAction<S>? {
        if let thunkAction = baseAction as? ThunkAction<S> {
            return thunkAction
        }
        if let mapAction = baseAction as? MapAction,
            let thunkAction = mapAction.originalAction as? ThunkAction<S> {
            return thunkAction
        }
        return nil
    }
}

struct MapAction: Action {
    let id: String
    let originalAction: Action
}

protocol ID: Hashable {
    var value: String { get set }
    init(value: Int)
    init(value: String)
}

extension ID {
    init(value: String) {
        self.init(value: value)
    }
    init(value: Int) {
        self.init(value: "\(value)")
    }
}

struct ThunkAction<S: ApplicationState>: Action {
    let function: (ReduxStore<S>, Action) async -> Action?
    let className: String
    let functionName: String
    
    init(function: @escaping (ReduxStore<S>, Action) async -> Action?,
         className: String,
         functionName: String = #function) {
        self.function = function
        self.className = className
        self.functionName = functionName
    }
    
    func caller() -> String {
        "\(className).\(functionName)"
    }
}

// name space
enum Middlewares {}
typealias Reducer<State: ApplicationState> = (State, ActionContainer) -> State
typealias Middleware<State: ApplicationState> = (ReduxStore<State>, State, ActionContainer) async -> Action?
typealias AfterMiddleware<State: ApplicationState> = (State, State, ActionContainer, ActionContainer) -> Void

actor ReduxStore<State: ApplicationState>: ObservableObject {
    @MainActor @Published private(set) var state: State = .init()
    
    private let initialState: State
    nonisolated private let reducer: Reducer<State>
    private let middleware: [Middleware<State>]
    nonisolated private let afterMiddleware: AfterMiddleware<State>?

    init(
        initialState: State,
        reducer: @escaping Reducer<State>,
        middleware: [Middleware<State>],
        afterMiddleware: AfterMiddleware<State>?
    ) {
        self.initialState = initialState
        self.reducer = reducer
        self.middleware = middleware
        self.afterMiddleware = afterMiddleware
        
        Task {
            await initializeState()
        }
    }
    
    func dispatch(action: MapAction, file: String = #fileID, line: Int = #line, function: String = #function) async {
        await dispatch(
            action,
            caller: "\(file):\(line) >>> \(function)"
        )
    }
    
    func dispatch(_ action: Action, file: String = #fileID, line: Int = #line, function: String = #function) async {
        await dispatch(action, caller: "\(file):\(line) >>> \(function)")
    }

    func dispatch(_ action: Action, caller: String) async {
        var currentAction: Action = action
        for m in middleware {
            if let converAction = await m(self, state, ActionContainer(caller: caller, baseAction: currentAction)) {
                currentAction = converAction
            }
        }
        let newActionContainer = ActionContainer(caller: caller, baseAction: currentAction)
        await MainActor.run {
            let currentState = state
            let newState = reducer(currentState, newActionContainer)
            afterMiddleware?(currentState,
                             newState,
                             ActionContainer(caller: caller, baseAction: action),
                             newActionContainer)
            state = newState
        }
    }
    
    private func initializeState() {
        Task { @MainActor in
            state = await initialState
        }
    }
}

extension ReduxStore where State == AppState {
    static let preview: ReduxStore<AppState> = {
        let mock = AppState.demos()
        return ReduxStore(
            initialState: AppState.demos() as! AppState,
            reducer: { state, _ in state },
            middleware: [],
            afterMiddleware: nil
        )
    }()
}
