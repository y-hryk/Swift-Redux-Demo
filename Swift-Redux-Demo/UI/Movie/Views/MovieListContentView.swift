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
        VStack {
            MovieListView(
                movieList: state.movieList,
                onPressed: { movieId in
                    Task {
                        await store.dispatch(
                            RoutingStateAction.showFromMovieList(
                                .movieDetail(state: MovieDetailState(movieId: movieId))
                            )
                        )
                    }
                },
                scrolledToBottom: { moviewList in
                    Task {
                        await store.dispatch(actionCreator.getMoreMovies(movieList: moviewList))
                    }
                }
            )
            .refreshable {
                await store.dispatch(actionCreator.getMovies())
            }
        }
        .navigationTitle("Top Rates")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.Background.main, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigation(path: Binding(
            get: { store.state.routingState.movieListPaths },
            set: { value in
                Task {
                    print(value)
                    await store.dispatch(RoutingStateAction.updateMovieList(value))
                }
            }
        ))
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
        .background(Color.Background.main)
//        .tint(Color.Text.body)
        .listStyle(.inset)
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
