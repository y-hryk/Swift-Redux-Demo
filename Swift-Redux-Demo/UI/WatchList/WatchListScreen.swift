//
//  WatchListScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListScreen: View {
    @StateObject var store: Redux.LocalStore<WatchListPageState>
//    @EnvironmentObject var stateObservationBuilder: StateObservationBuilder

    @StateBinding(\.routingState.watchListPaths, default: []) var watchListPaths
    @StateBinding(\.favoriteState.favoriteItems, default: []) var favoriteItems
//    @State private var watchListPaths: [RoutingPath] = []
//    @State private var favoriteItems: [MovieDetail] = []

    var body: some View {
        let _ = print("WatchListScreen body")
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
//        .observingStates(from: stateObservationBuilder) { builder in
//            builder.observe(\.routingState.watchListPaths, default: [], into: $watchListPaths)
//            builder.observe(\.favoriteState.favoriteItems, default: [], into: $favoriteItems)
//        }
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: WatchListPageState())
        .build()

    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    
    WatchListScreen(store: store)
        .environment(\.globalStore, globalStore)
}
