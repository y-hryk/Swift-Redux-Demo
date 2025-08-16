//
//  MaintenanceViewState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

struct MaintenancePageState: Redux.State {

}

extension MaintenancePageState {
    static func preview() -> MaintenancePageState {
        return .init()
    }
}

extension MaintenancePageState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        return state
    }
}
