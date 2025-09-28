//
//  DeepLinkState.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/04.
//

struct DeepLinkState: Redux.State {
    var deepLink: DeepLink?
}

extension DeepLinkState {
    static func preview() -> DeepLinkState {
        .init()
    }
}

extension DeepLinkState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        guard let action = action as? DeepLinkAction else { return state }
        
        switch action {
        case .deepLinkReceived(let deepLink):
            state.deepLink = deepLink
        }
        return state
    }
}
