//
//  TabState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import SwiftUI

enum Tab {
    case movie
    case watchList
    case debug
}

struct TabState: ApplicationState {
    var seleced: Tab
    var moviePageState: MoviePageState
    var settingsPageState: DebugPageState
}

extension TabState {
    init() {
        seleced = .movie
        moviePageState = MoviePageState()
        settingsPageState = DebugPageState()
    }
}
