//
//  DebugStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import UIKit

enum DebugPageStateAction: Action {
    case task(number: Int, delay: Int)
    case increment
}

struct DebugPageStateActionCreator: Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func counterIncrementCounter(number: Int, delay: Int) async -> Action {
        try? await Task.sleep(for: .seconds(delay))
        return DebugPageStateAction.task(number: number, delay: delay)
    }
}
