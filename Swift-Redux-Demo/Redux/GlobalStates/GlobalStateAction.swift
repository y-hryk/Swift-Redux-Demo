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

struct GlobalStateActionCreator: Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
}
