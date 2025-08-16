//
//  TabState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import SwiftUI

struct TabState: Redux.State {
    
}

extension TabState {
    static func preview() -> TabState {
        .init()
    }
}

extension TabState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
}
