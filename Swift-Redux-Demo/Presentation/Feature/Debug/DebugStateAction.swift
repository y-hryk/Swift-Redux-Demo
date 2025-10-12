//
//  DebugStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import UIKit

enum DebugStateAction: Redux.Action {
    case task(number: Int, delay: Int)
    case increment
}

struct DebugStateActionCreator<State: Redux.State> {
    func counterIncrementCounter_(number: Int, delay: Int) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            try? await Task.sleep(for: .seconds(delay))
            return DebugStateAction.task(number: number, delay: delay)
        }, className: "\(type(of: self))")
    }
}
