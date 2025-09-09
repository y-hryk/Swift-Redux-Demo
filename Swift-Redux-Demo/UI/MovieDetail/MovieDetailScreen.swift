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
        VStack(alignment: .leading, spacing: 0.0) {
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
                        .font(.titleS())
                    Text("Reviewers")
                        .font(.captionM())
                }
                ScoreView(score: movieDetail.rate)
                    .frame(width: 60, height: 60)
            }
            Spacer().frame(height: 20)
            Text(movieDetail.title)
                .font(.titleM())
            + Text(" (\(movieDetail.year))")
                .font(.titleS())
            Text(movieDetail.screeningTime)
            Spacer().frame(height: 20)
            if !movieDetail.overview.isEmpty {
                Text("Stories")
                    .font(.subTitleL())
                Spacer().frame(height: 20)
                Text(movieDetail.overview)
                    .font(.bodyM())
                Spacer().frame(height: 20)
            }
            BackdropView(backdrops: store.state.backdrops)
            Spacer().frame(height: 20)
            CastListView(creditList: store.state.creditList) { personId in
                Task {
                    await store.dispatch(RoutingStateAction.routePushed(.filmography(personId: personId, type: .cast)))
                }
            }
            Spacer().frame(height: 20)
            AboutFilmView(movieDetail: movieDetail, creditList: store.state.creditList)
            Spacer().frame(height: 20)
            CreatorListView(creditList: store.state.creditList) { personId in
                Task {
                    await store.dispatch(RoutingStateAction.routePushed(.filmography(personId: personId, type: .crew)))
                }
            }
            Spacer().frame(height: 20)
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
        initialState: GlobalState.preview(),
        reducer: GlobalState.reducer,
        afterMiddleware: Redux.traceAfterMiddleware()
    )
    MovieDetailScreen(store: store,
                      movieDetailStateActionCreator: ActionCreatorAssembler().resolve(movieId: MovieId(value: "1")))
        .environment(\.globalStore, globalStore)
}
