//
//  SplashPageState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

struct SplashPageState: Redux.State {
    
}

extension SplashPageState {
    static func preview() -> SplashPageState {
        return .init()
    }
}

extension SplashPageState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
}
