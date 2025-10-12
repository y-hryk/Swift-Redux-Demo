//
//  MovieListScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import SwiftUI

struct MovieListScreen: View {
    @StateBinding(\.routingState.movieListPaths, default: []) var movieListPaths
    @StateObject var store: Redux.LocalStore<MovieListState>
    let actionCreator: MovieListStateActionCreator<MovieListState>
    
    init(state: MovieListState,
         actionCreator: MovieListStateActionCreator<MovieListState>,
         type: Redux.LocalStoreType = .normal) {
        _store = StateObject(wrappedValue: LocalStoreBuilder.create(initialState: state, type: type)
            .build()
        )
        self.actionCreator = actionCreator
    }
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { movieListPaths },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.movieListNavigationsChanged(value))
                }
            }
        )) {
            content(movieList: store.state.movieList)
            .navigationTitle("Top Rates")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: RoutingPath.self) { path in
                path.destination()
            }
        }
        .onDidLoad() {
            Task {
                await store.dispatch(actionCreator.movieListRequested())
            }
        }
    }
    
    @ViewBuilder
    func content(movieList: AsyncValue<MovieList>) -> some View {
        switch movieList {
        case .data, .loading:
            MovieListView(
                movieList: movieList,
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
        case .error:
            ErrorView() {
                Task {
                    await store.dispatch(actionCreator.movieListRequested())
                }
            }
        }
    }
}

#Preview {
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    MovieListScreen(state: MovieListState.preview(),
                    actionCreator: MovieListStateActionCreator(),
                    type: .stub)
        .environment(\.globalStore, globalStore)
}

#Preview("loading") {
    let state = MovieListState(movieList: .loading)
    let store = LocalStoreBuilder
        .stub(state: state)
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    MovieListScreen(state: MovieListState(movieList: .loading),
                    actionCreator: MovieListStateActionCreator(),
                    type: .stub)
        .environment(\.globalStore, globalStore)
}

#Preview("error") {
    let state = MovieListState(movieList: .error(error: NetworkError.badRequest(code: 400, message: "")))
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    MovieListScreen(state: state,
                    actionCreator: MovieListStateActionCreator(),
                    type: .stub)
        .environment(\.globalStore, globalStore)
}

