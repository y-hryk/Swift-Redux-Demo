//
//  DeepLinkAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/04.
//

enum DeepLinkAction: Redux.GlobalAction {
    case updateDeepLink(DeepLink?)
}

struct DeepLinkStateActionCreator<State: Redux.State> {
    
    func execute(deepLink: DeepLink?) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            guard let to = deepLink?.to else { return nil }
            await store.dispatch(RoutingStateAction.resetAll)
            switch to {
            case .movieList:
                await store.dispatch(RoutingStateAction.selectTab(tab: .movie))
            case .watchList:
                await store.dispatch(RoutingStateAction.selectTab(tab: .watchList))
            case .movieDetail(let movieId):
                await store.dispatch(RoutingStateAction.selectTab(tab: .movie))
                await store.dispatch(RoutingStateAction.push(.movieDetail(movieId: movieId)))
            case .firstModal:
                await store.dispatch(RoutingStateAction.showModal(ModalItem(routingPath: .debugFirstModel)))
            }
            return DeepLinkAction.updateDeepLink(nil)
        }, className: "\(type(of: self))")
    }
}
