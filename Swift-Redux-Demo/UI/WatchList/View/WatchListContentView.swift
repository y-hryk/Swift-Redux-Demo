//
//  WatchListContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/06.
//

import SwiftUI

struct WatchListContentView: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    let actionCreator: WatchListStateActionCreator = ActionCreatorAssembler().resolve()
    var state: WatchListPageState { store.state.routingState.tabState.watchListPageState }
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { store.state.routingState.watchListPaths },
            set: { value,_ in
                Task {
                    await store.dispatch(RoutingStateAction.updateWatchList(value))
                }
            }
        )) {
            ZStack {
                WatchListView(movies: state.movies) { movie in
                    Task {
                        await store.dispatch(RoutingStateAction.showFromWatchList(.movieDetail(movieId: movie.id))
                        )
                    }
                }
            }
            .onDidLoad {
                Task {
                    await store.dispatch(actionCreator.getFavorites())
                }
            }
            .navigationTitle("Watch List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.Background.main, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Background.main)
            .navigationDestination(for: NavigationStackPath.self) { path in
                path.destination()
            }
        }
    }
}

#Preview {
    WatchListContentView()
        .environmentObject(store)
}
