//
//  SettingsPageState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/12.
//

import SwiftUI

struct DebugPageState: Redux.State {
    var count: Int
}

extension DebugPageState {
    init() {
        self.count = 0
    }
}
