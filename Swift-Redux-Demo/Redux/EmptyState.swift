//
//  EmptyState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/16.
//

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
