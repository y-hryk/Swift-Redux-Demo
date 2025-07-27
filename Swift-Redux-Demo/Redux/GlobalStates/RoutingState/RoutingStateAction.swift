//
//  RoutingStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

enum RoutingStateAction: Redux.GlobalAction {
    case selectTab(tab: Tab)
    case updateMovieList([RoutingPath])
    case updateWatchList([RoutingPath])
    case showFromMovieList(RoutingPath)
    case showFromWatchList(RoutingPath)
    case showModal(ModalItem)
    case updateModel([ModalItem])
}
