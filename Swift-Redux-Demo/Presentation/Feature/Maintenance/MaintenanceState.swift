//
//  MaintenanceViewState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

struct MaintenanceState: Redux.State {

}

extension MaintenanceState {
    static func preview() -> MaintenanceState {
        return .init()
    }
}

extension MaintenanceState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
}
