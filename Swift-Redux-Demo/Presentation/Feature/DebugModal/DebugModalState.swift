//
//  DebugModalState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/09.
//

struct DebugModalState: Redux.State {

}

extension DebugModalState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
    
    static func preview() -> DebugModalState {
        return .init()
    }
}
