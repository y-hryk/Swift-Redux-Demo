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
    
    init(state: MovieDetailState,
         actionCreator: MovieDetailStateActionCreator<MovieDetailState>,
         type: Redux.LocalStoreType = .normal) {
        
        _store = StateObject(wrappedValue: LocalStoreBuilder
            .create(initialState: state, type: type)
            .build()
        )
        self.movieDetailStateActionCreator = actionCreator
    }
    
    var body: some View {
        content(movieDetail: store.state.movie)
            .background(Color.Background.main)
            .onDidLoad {
                Task {
                    await store.dispatch(movieDetailStateActionCreator.getMovieDetail())
                }
            }
    }
    
    @ViewBuilder
    func content(movieDetail: AsyncValue<MovieDetail>) -> some View {
        switch movieDetail {
        case .data, .loading:
            MovieDetailScrollView(movieDetail: movieDetail, colorScheme: colorScheme) { movieDetail in
                detail(movieDetail: movieDetail)
            }
            .onDidLoad {
                Task {
                    await store.dispatch(movieDetailStateActionCreator.getImages())
                    await store.dispatch(movieDetailStateActionCreator.getCreditList())
                    await store.dispatch(movieDetailStateActionCreator.getReviews())
                }
            }
        case .error:
            ErrorView() {
                Task {
                    await store.dispatch(movieDetailStateActionCreator.getMovieDetail())
                }
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
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    
    MovieDetailScreen(
        state: MovieDetailState.preview(),
        actionCreator: MovieDetailStateActionCreator(movieId: MovieId(value: "1")),
        type: .stub)
        .environment(\.globalStore, globalStore)
}
