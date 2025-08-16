//
//  WatchListContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListContentView: View {
    @StateObject var store: Redux.LocalStore<WatchListPageState>
    @StateBinding(\.routingState.watchListPaths, default: []) var watchListPaths
    @StateBinding(\.favoriteState.favoriteItems, default: []) var favoriteItems

    var body: some View {
        NavigationStack(path: Binding(
            get: { watchListPaths },
            set: { value,_ in
                Task {
                    await store.dispatch(RoutingStateAction.watchListNavigationsChanged(value))
                }
            }
        )) {
            ZStack {
                WatchListView(movies: favoriteItems) { movie in
                    Task {
                        await store.dispatch(RoutingStateAction.routePushed(.movieDetail(movieId: movie.id))
                        )
                    }
                }
            }
            .navigationTitle("Watch List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.Background.main, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Background.main)
            .navigationDestination(for: RoutingPath.self) { path in
                path.destination()
            }
        }
    }
}

#Preview {
    let store = LocalStoreBuilder.stub(state: WatchListPageState())
    let globalStore = Redux.GlobalStore(
        initialState: GlobalState.preview(),
        reducer: GlobalState.reducer,
        afterMiddleware: Redux.traceAfterMiddleware()
    )
    WatchListContentView(store: store)
        .environment(\.globalStore, globalStore)
}
