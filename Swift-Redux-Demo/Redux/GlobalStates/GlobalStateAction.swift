//
//  GlobalStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import UIKit

enum GlobalStateAction: Redux.GlobalAction {
    case didReceiveError(Error)
    case update(startScreen: StartScreen)
    case showIndicator(Bool)
}
