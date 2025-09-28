//
//  WatchListScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListScreen: View {
    @StateObject var store: Redux.LocalStore<WatchListState>
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
            .navigationDestination(for: RoutingPath.self) { path in
                path.destination()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Background.main)
        }
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: WatchListState())
        .build()

    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    
    WatchListScreen(store: store)
        .environment(\.globalStore, globalStore)
}
