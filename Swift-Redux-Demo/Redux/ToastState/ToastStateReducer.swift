//
//  ToastStateReducer.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/27.
//

import Foundation

extension ToastState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case ToastStateAction.didReceiveToast(let toast):
            state.toast = toast
        default: break
        }
        return ToastState(toast: state.toast)
    }
}
