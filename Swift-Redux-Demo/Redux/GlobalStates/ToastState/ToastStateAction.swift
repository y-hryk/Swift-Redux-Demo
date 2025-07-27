//
//  ToastStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/27.
//

import Foundation

enum ToastStateAction: Redux.GlobalAction {
    case didReceiveToast(Toast?)
}
