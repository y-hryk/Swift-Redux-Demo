//
//  ToastState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/27.
//

struct ToastState: Redux.State, Equatable {
    var toast: Toast?
}

extension ToastState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case ToastStateAction.didReceiveToast(let toast):
            state.toast = toast
        default: break
        }
        return ToastState(toast: state.toast)
    }
}
