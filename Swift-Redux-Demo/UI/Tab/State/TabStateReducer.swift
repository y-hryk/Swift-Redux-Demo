//
//  TabStateReducer.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import Foundation

extension TabState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case TabStateAction.select(tab: .movie):
            state.seleced = .movie
        case TabStateAction.select(tab: .watchList):
            state.seleced = .watchList
        case TabStateAction.select(tab: .debug):
            state.seleced = .debug
        default: break
        }
        return TabState(
            seleced: state.seleced,
            moviePageState: MoviePageState.reducer(state.moviePageState, actionContainer),
            settingsPageState: DebugPageState.reducer(state.settingsPageState, actionContainer)
        )
    }
}
