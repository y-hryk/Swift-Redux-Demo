//
//  RoutingStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

enum RoutingStateAction: Redux.GlobalAction {
    case selectTab(tab: Tab)
    case push(RoutingPath)
    case pop
    case updateMovieList([RoutingPath])
    case updateWatchList([RoutingPath])
    case showModal(ModalItem)
    case dismiss
    case updateModel([ModalItem])
}
