//
//  ReduxStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

enum NavigationStackPath: Hashable {
    case movieDetail(state: MovieDetailState)
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .movieDetail(let state):
            MovieDetailContentView(movieId: state.movieId)
        }
    }
    
    func state() -> any ApplicationState {
        switch self {
        case .movieDetail(let state):
            return state
        }
    }
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
}

protocol PageState: ApplicationState {
    func mapAction(action: Action)
}

protocol Action {}

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
    let id: any ID
    let originalAction: Action
}

struct MapAction2<State: ApplicationState>: Action {
    let id: any ID
    let originalAction: Action
    let reducer: Reducer<State>
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

    nonisolated private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    nonisolated private let afterMiddlerare: AfterMiddleware<State>?

    init(
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>],
        afterMiddlerare: AfterMiddleware<State>?
    ) {
        self.reducer = reducer
        self.middlewares = middlewares
        self.afterMiddlerare = afterMiddlerare
    }
    
    func dispatch(id: any ID, _ action: Action, file: String = #fileID, line: Int = #line, function: String = #function) async {
        await dispatch(
            MapAction(id: id, originalAction: action),
            caller: "\(file):\(line) >>> \(function)"
        )
    }
    
    func dispatch(_ action: Action, file: String = #fileID, line: Int = #line, function: String = #function) async {
        await dispatch(action, caller: "\(file):\(line) >>> \(function)")
    }

    func dispatch(_ action: Action, caller: String) async {
        var currentAction: Action = action
        for middleware in middlewares {
            if let converAction = await middleware(self, state, ActionContainer(caller: caller, baseAction: currentAction)) {
                currentAction = converAction
            }
        }
        let newActionContainer = ActionContainer(caller: caller, baseAction: currentAction)
        await MainActor.run {
            let currentState = state
            let newState = reducer(currentState, newActionContainer)
            afterMiddlerare?(currentState,
                             newState,
                             ActionContainer(caller: caller, baseAction: action),
                             newActionContainer)
            state = newState
        }
    }
}
