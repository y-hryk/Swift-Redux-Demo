//
//  AppState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import Foundation

struct AppState: ApplicationState {
    var globalState: GlobalState
    var routingState: RoutingState
    var toastState: ToastState
    var pageState: [String: any ApplicationState]
    
    func find<State: ApplicationState>(stateID: String? = nil) -> State {
        let state = pageState.first { key, value in
            if let stateID = stateID {
                return value is State && value.stateIdentifier == stateID
            }
            return value is State
        }?.value as? State
        return state ?? State()
    }
}

extension AppState {
    init() {
        globalState = GlobalState()
        routingState = RoutingState()
        toastState = ToastState()
        pageState = [:]
    }
    
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case GlobalStateAction.update(let starScreen):
            if starScreen == .splash {
                state.globalState = GlobalState()
                state.routingState = RoutingState()
            }
        default: break
        }
        
//        if let mapAction = actionContainer.mapAction() {
//
////            state.pageState[mapAction.id]
//        }
//        
//        state.pageState = state.pageState.mapValues {
//            switch $0 {
//            case let state as MovieDetailState:
//                return MovieDetailState.reducer(state, actionContainer)
//            default: return $0
//            }
//        }
        
        return AppState(
            globalState: GlobalState.reducer(state.globalState, actionContainer),
            routingState: RoutingState.reducer(state.routingState, actionContainer),
            toastState: ToastState.reducer(state.toastState, actionContainer),
            pageState: state.pageState
        )
    }
}
