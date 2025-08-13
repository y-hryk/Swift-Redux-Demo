//
//  RoutingStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

enum RoutingStateAction: Redux.GlobalAction {
    case tabSelected(tab: Tab)
    case routePushed(RoutingPath)
    case routePopped
    case movieListNavigationsChanged([RoutingPath])
    case watchListNavigationsChanged([RoutingPath])
    case modalShown(ModalItem)
    case modalDismissed
    case modalNavigationsChanged([ModalItem])
    case routingStateReset
}
