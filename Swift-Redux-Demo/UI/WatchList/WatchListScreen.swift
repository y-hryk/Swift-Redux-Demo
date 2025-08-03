//
//  WatchListContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListContentView: View {
    @EnvironmentObject var globalStore: Redux.GlobalStore
    @StateObject var store: Redux.LocalStore<WatchListPageState>
    let actionCreator: FavoriteStateActionCreator<WatchListPageState>
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { globalStore.state.routingState.watchListPaths },
            set: { value,_ in
                Task {
                    await store.dispatch(RoutingStateAction.updateWatchList(value))
                }
            }
        )) {
            ZStack {
                WatchListView(movies: globalStore.state.favoriteState.favoriteItems) { movie in
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
        .onDidLoad() {
//            Task {
//                await store.dispatch(actionCreator.getFavorites())
//            }
        }
    }
}

#Preview {
//    WatchListContentView()
//        .environmentObject(store)
}
