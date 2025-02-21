//
//  RoutingStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

enum RoutingStateAction: Action {
    case updateMovieList([NavigationStackPath])
    case showFromMovieList(NavigationStackPath)
    case setInitialState(state: any ApplicationState)
}
