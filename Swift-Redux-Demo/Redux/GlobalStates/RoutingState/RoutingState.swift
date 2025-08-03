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
        
        guard let action = action as? RoutingStateAction else {
            return state
        }
        
        switch action {
        case RoutingStateAction.selectTab(let tab):
            state.selecedTab = tab
            
        case RoutingStateAction.push(let navigation):
            switch state.selecedTab {
            case .movie:
                state.movieListPaths.append(navigation)
            case .watchList:
                state.watchListPaths.append(navigation)
            case .debug: break
            }
        case RoutingStateAction.pop:
            switch state.selecedTab {
            case .movie:
                state.movieListPaths.removeLast()
            case .watchList:
                state.watchListPaths.removeLast()
            case .debug: break
            }

        case RoutingStateAction.updateMovieList(let paths):
            let difference = state.movieListPaths.filter { !paths.contains($0) }
            state.movieListPaths = paths
            
        case RoutingStateAction.updateWatchList(let paths):
            let difference = state.watchListPaths.filter { !paths.contains($0) }
            state.watchListPaths = paths
            
        case RoutingStateAction.showModal(let navigation):
            state.modalPaths.append(navigation)
            
        case RoutingStateAction.dismiss:
            state.modalPaths.removeLast()
            
        case RoutingStateAction.updateModel(let paths):
            state.modalPaths = paths
            
        }
        
        return RoutingState(
            selecedTab: state.selecedTab,
            movieListPaths: state.movieListPaths,
            watchListPaths: state.watchListPaths,
            modalPaths: state.modalPaths
        )
    }
}
