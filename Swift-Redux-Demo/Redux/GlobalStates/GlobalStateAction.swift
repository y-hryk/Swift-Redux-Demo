//
//  GlobalStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/09.
//

import UIKit

enum GlobalStateAction: Action {
    case didReceiveError(Error)
    case update(startScreen: StartScreen)
}

struct GlobalStateActionCreator: Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
}
