//
//  DeepLinkAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/04.
//

enum DeepLinkAction: Redux.GlobalAction {
    case deepLinkReceived(DeepLink?)
}

struct DeepLinkStateActionCreator<State: Redux.State> {
    func startDeepLink(deepLink: DeepLink?) async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            guard let to = deepLink?.to else { return nil }
            await store.dispatch(RoutingStateAction.routingStateReset)
            switch to {
            case .movieList:
                await store.dispatch(RoutingStateAction.tabSelected(tab: .movie))
            case .watchList:
                await store.dispatch(RoutingStateAction.tabSelected(tab: .watchList))
            case .movieDetail(let movieId):
                await store.dispatch(RoutingStateAction.tabSelected(tab: .movie))
                await store.dispatch(RoutingStateAction.routePushed(.movieDetail(movieId: movieId)))
            case .firstModal:
                await store.dispatch(RoutingStateAction.modalShown(ModalItem(routingPath: .debugFirstModel)))
            }
            return DeepLinkAction.deepLinkReceived(nil)
        }, className: "\(type(of: self))")
    }
}
