//
//  Redux.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/15.
//

struct Redux {
    typealias Reducer<State: Redux.State> = @Sendable (State, Redux.Action) -> State
    typealias Middleware<State: Redux.State> = @Sendable (Redux.LocalStore<State>, Redux.Action) async -> Redux.Action?
    
    // State
    protocol State: Equatable, Sendable {
        static var reducer: Redux.Reducer<Self> { get }
        static func preview() -> Self
    }
    
    // Action
    protocol Action: Sendable {}
    protocol GlobalAction: Redux.Action {}
    
    struct ThunkAction<S: Redux.State>: Action {
        let function: @Sendable (Redux.LocalStore<S>, Action) async -> Action?
        let className: String
        let functionName: String
        
        init(function: @Sendable @escaping (Redux.LocalStore<S>, Action) async -> Action?,
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
