//
//  HomePage.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import SwiftUI

struct MovieListContentView: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    @EnvironmentObject var appEnvironment: AppEnvironment
    let actionCreator: MoviePageStateActionCreator = ActionCreatorAssembler().resolve()
    var state: MoviePageState { store.state.routingState.tabState.moviePageState }
    
    var body: some View {
        MovieListView(
            movieList: state.movieList,
            onPressed: { movieId in
                Task {
                    await store.dispatch(RoutingStateAction.showFromMovieList(.movieDetail(movieId: movieId))
                    )
                }
            },
            refreshHandler: {
                await store.dispatch(actionCreator.getMovies())
            },
            scrolledToBottom: { moviewList in
                Task {
                    await store.dispatch(actionCreator.getMoreMovies(movieList: moviewList))
                }
            }
        )
        .navigationTitle("Top Rates")
        .navigationBarTitleDisplayMode(.inline)
        .navigation(path: Binding(
            get: { store.state.routingState.movieListPaths },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.updateMovieList(value))
                }
            }
        ))
        .toolbarBackground(Color.Background.main, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            Button(action: {
                Task {
                    await store.dispatch(GlobalStateAction.update(startScreen: .splash))
                }
            }, label: {
                Image(systemName: "person.crop.circle")
                    .tint(Color("tint_color"))
            })
        }
        .onDidLoad() {
            Task {
                await store.dispatch(actionCreator.getMovies())
            }
        }
    }
}

#Preview {
    MovieListContentView()
        .environmentObject(store)
}
