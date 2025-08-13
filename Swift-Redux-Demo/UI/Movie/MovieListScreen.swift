//
//  MovieListScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import SwiftUI

struct MovieListScreen: View {
    @StateBinding(\.routingState.movieListPaths, default: []) var movieListPaths
    @StateObject var store: Redux.LocalStore<MoviePageState>
    let actionCreator: MoviePageStateActionCreator<MoviePageState>
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { movieListPaths },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.movieListNavigationsChanged(value))
                }
            }
        )) {
            MovieListView(
                movieList: store.state.movieList,
                onPressed: { movieId in
                    Task {
                        await store.dispatch(RoutingStateAction.routePushed(.movieDetail(movieId: movieId))
                        )
                    }
                },
                refreshHandler: {
                    await store.dispatch(actionCreator.movieListRequested())
                },
                scrolledToBottom: { moviewList in
                    Task {
                        await store.dispatch(actionCreator.movieListMoreRequested(movieList: moviewList))
                    }
                }
            )
            .navigationTitle("Top Rates")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: RoutingPath.self) { path in
                path.destination()
            }
            .toolbarBackground(Color.Background.main, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onDidLoad() {
            Task {
                await store.dispatch(actionCreator.movieListRequested())
            }
        }
        .onAppear {
            print("viewwill Appear")
        }
    }
}

#Preview {
//    MovieListContentView()
//        .environmentObject(store)
}
