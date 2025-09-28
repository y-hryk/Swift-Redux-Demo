//
//  ApplicationAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/04.
//

enum ApplicationAction: Redux.GlobalAction {
    case errorReceived(Error)
    case startScreenChanged(startScreen: StartScreen)
    case indicatorShown(Bool)
}
