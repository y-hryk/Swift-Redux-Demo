//
//  WatchListContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListContentView: View {
    @StateObject var store: Redux.LocalStore<WatchListPageState>
    @EnvironmentObject var stateObservationBuilder: StateObservationBuilder
//    @StateBinding(\.routingState.watchListPaths, default: []) var watchListPaths
//    @StateBinding(\.favoriteState.favoriteItems, default: []) var favoriteItems
    @State private var watchListPaths: [RoutingPath] = []
    @State private var favoriteItems: [MovieDetail] = []


    
    var body: some View {
        NavigationStack(path: Binding(
            get: { watchListPaths },
            set: { value,_ in
                Task {
                    await store.dispatch(RoutingStateAction.updateWatchList(value))
                }
            }
        )) {
            ZStack {
                WatchListView(movies: favoriteItems) { movie in
                    Task {
                        await store.dispatch(RoutingStateAction.push(.movieDetail(movieId: movie.id))
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
        .observingStates(from: stateObservationBuilder) {
            StateModifierObservation.observe(\.routingState.watchListPaths, default: [], into: $watchListPaths)
            StateModifierObservation.observe(\.favoriteState.favoriteItems, default: [], into: $favoriteItems)
        }
    }
}

#Preview {
//    WatchListContentView()
//        .environmentObject(store)
}
