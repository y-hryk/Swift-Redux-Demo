//
//  SplashState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

struct SplashState: Redux.State {
    
}

extension SplashState {
    static func preview() -> SplashState {
        return .init()
    }
}

extension SplashState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
}
