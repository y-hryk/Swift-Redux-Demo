//
//  Redux.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

struct Redux {
    typealias Reducer<State: Redux.State> = (State, Redux.Action) -> State
    typealias Middleware<State: Redux.State> = (Redux.LocalStore<State>, Redux.Action) async -> Redux.Action?
    typealias AfterMiddleware<State: Redux.State> = (State, State, Redux.Action, Redux.Action) -> Void
    
    // State
    protocol State {
        static var reducer: Redux.Reducer<Self> { get }
    }
    
    // Action
    protocol Action {}
    protocol GlobalAction: Redux.Action {}
    
    struct ThunkAction<S: Redux.State>: Action {
        let function: (Redux.LocalStore<S>, Action) async -> Action?
        let className: String
        let functionName: String
        
        init(function: @escaping (Redux.LocalStore<S>, Action) async -> Action?,
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
}

extension Redux.State {
    var className: String {
        String(describing: type(of: self))
    }
}
