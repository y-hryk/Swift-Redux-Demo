//
//  MovieDetailScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import SwiftUI

struct MovieDetailScreen: View {
    @StateObject var store: Redux.LocalStore<MovieDetailState>
    @Environment(\.colorScheme) var colorScheme
    @StateBinding(\.favoriteState, default: FavoriteState()) var favoriteState
    let movieDetailStateActionCreator: MovieDetailStateActionCreator<MovieDetailState>
    
    var body: some View {
        MovieDetailScrollView(
            state: store.state,
            colorScheme: colorScheme) { movieDetail in
                detail(movieDetail: movieDetail)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color.Background.main)
            .onDidLoad {
                Task {
                    await store.dispatch(movieDetailStateActionCreator.getMovieDetail())
                    await store.dispatch(movieDetailStateActionCreator.getImages())
                    await store.dispatch(movieDetailStateActionCreator.getCreditList())
                    await store.dispatch(movieDetailStateActionCreator.getReviews())
                }
            }
    }
    
    func detail(movieDetail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center, spacing: 16) {
                FavoriteButton(isFavorite: favoriteState.isFavorite(movieId: movieDetail.id)) { isFavorite in
                    Task {
                        if isFavorite {
                            await store.dispatch(FavoriteStateAction.movieRemovedFromFavorites(movieDetail))
                        } else {
                            await store.dispatch(FavoriteStateAction.movieAddedToFavorites(movieDetail))
                        }
                    }
                }
                VStack(alignment: .center ,spacing: 0.0) {
                    Text("\(movieDetail.reviewersCount)")
                        .font(.title25())
                    Text("Reviewers")
                        .font(.body40())
                }
                ScoreView(score: movieDetail.rate)
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading, spacing: 5.0) {
                Text(movieDetail.title)
                    .font(.title50())
                + Text(" (\(movieDetail.year))")
                    .font(.title25())
                Text(movieDetail.screeningTime)
                    .font(.body45())
            }
            if !movieDetail.overview.isEmpty {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Stories")
                        .font(.title25())
                    Text(movieDetail.overview)
                        .font(.body50())
                }
            }
            BackdropView(backdrops: store.state.backdrops)
            CastListView(creditList: store.state.creditList) { personId in
                Task {
                    await store.dispatch(RoutingStateAction.routePushed(.filmography(personId: personId, type: .cast)))
                }
            }
            AboutFilmView(movieDetail: movieDetail, creditList: store.state.creditList)
            CreatorListView(creditList: store.state.creditList) { personId in
                Task {
                    await store.dispatch(RoutingStateAction.routePushed(.filmography(personId: personId, type: .crew)))
                }
            }
            ReviewView(reviews: store.state.reviews)
        }
        .padding()
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: MovieDetailState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    MovieDetailScreen(store: store,
                      movieDetailStateActionCreator: ActionCreatorAssembler().resolve(movieId: MovieId(value: "1")))
        .environment(\.globalStore, globalStore)
}
