//
//  AppState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import Foundation

//struct AppState: ApplicationState {
//    var globalState: GlobalState
//    var routingState: RoutingState
//    var toastState: ToastState
//}
//
//extension AppState {
//    init() {
//        globalState = GlobalState()
//        routingState = RoutingState()
//        toastState = ToastState()
//    }
//    
//    static func demos() -> any ApplicationState {
//        AppState(
//            globalState: GlobalState(),
//            routingState: RoutingState.demos() as! RoutingState,
//            toastState: ToastState()
//        )
//    }
//    
//    static let reducer: Reducer<Self> = { state, actionContainer in
//        var state = state
//        switch actionContainer.action {
//        case GlobalStateAction.update(let starScreen):
//            if starScreen == .splash {
//                state.globalState = GlobalState()
//                state.routingState = RoutingState()
//            }
//        default: break
//        }
//        
//        return AppState(
//            globalState: GlobalState.reducer(state.globalState, actionContainer),
//            routingState: RoutingState.reducer(state.routingState, actionContainer),
//            toastState: ToastState.reducer(state.toastState, actionContainer)
//        )
//    }
//}
