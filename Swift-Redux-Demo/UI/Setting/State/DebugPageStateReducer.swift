//
//  DebugStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/12.
//

import SwiftUI

extension DebugPageState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var newer = state
        switch actionContainer.action {
        case DebugPageStateAction.task:
            return newer
        case DebugPageStateAction.increment:
            newer.count += 1
        default:
            return newer
        }
        return newer
    }
}
