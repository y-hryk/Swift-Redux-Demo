//
//  HomePage.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import SwiftUI

struct MovieListContentView: View {
    @EnvironmentObject var globalStore: Redux.GlobalStore
    @StateObject var store: Redux.LocalStore<MoviePageState>
    let actionCreator: MoviePageStateActionCreator<MoviePageState>
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { globalStore.state.routingState.movieListPaths },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.updateMovieList(value))
                }
            }
        )) {
            MovieListView(
                movieList: store.state.movieList,
                onPressed: { movieId in
                    Task {
                        await store.dispatch(RoutingStateAction.push(.movieDetail(movieId: movieId))
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
            .navigationDestination(for: RoutingPath.self) { path in
                path.destination()
            }
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
        }
        .onDidLoad() {
            Task {
                await store.dispatch(actionCreator.getMovies())
            }
        }
        .onAppear {
            print("viewwill Appear")
        }
        .onChange(of: globalStore.state.routingState.movieListPaths.count) { oldValue, newValue in
            // スタックが減った時（戻ってきた時）にrefresh
            if oldValue > newValue {
                print("++ refresh")
            }
        }
    }
}

#Preview {
//    MovieListContentView()
//        .environmentObject(store)
}
