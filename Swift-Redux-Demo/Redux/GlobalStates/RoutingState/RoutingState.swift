//
//  RoutingState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

enum Tab {
    case movie
    case watchList
    case debug
}

struct RoutingState: Redux.State, Equatable {
    // tab
    var selecedTab: Tab
    // NavitionsStacks
    var movieListPaths: [RoutingPath]
    var watchListPaths: [RoutingPath]
    // mobal
    var modalPaths: [ModalItem]
}

extension RoutingState {
    init() {
        selecedTab = .movie
        movieListPaths = []
        watchListPaths = []
        modalPaths = []
    }
}

extension RoutingState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case RoutingStateAction.selectTab(let tab):
            state.selecedTab = tab
        case RoutingStateAction.updateMovieList(let paths):
            let difference = state.movieListPaths.filter { !paths.contains($0) }
            state.movieListPaths = paths
            
        case RoutingStateAction.showFromMovieList(let navigation):
            state.movieListPaths.append(navigation)
            
        case RoutingStateAction.updateWatchList(let paths):
            let difference = state.watchListPaths.filter { !paths.contains($0) }
            state.watchListPaths = paths
            
        case RoutingStateAction.showFromWatchList(let navigation):
            state.watchListPaths.append(navigation)
            
        case RoutingStateAction.showModal(let navigation):
            state.modalPaths.append(navigation)
            
        case RoutingStateAction.updateModel(let paths):
            state.modalPaths = paths
            
        default: break
        }
        
        return RoutingState(
            selecedTab: state.selecedTab,
            movieListPaths: state.movieListPaths,
            watchListPaths: state.watchListPaths,
            modalPaths: state.modalPaths
        )
    }
}
