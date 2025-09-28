//
//  DebugState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/12.
//

import SwiftUI

struct DebugState: Redux.State {
    var count: Int
}

extension DebugState {
    init() {
        self.count = 0
    }
    
    static func preview() -> DebugState {
        DebugState(count: 0)
    }
}

extension DebugState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var newer = state
        switch action {
        case DebugStateAction.task:
            return newer
        case DebugStateAction.increment:
            newer.count += 1
        default:
            return newer
        }
        return newer
    }
}
