//
//  FilmographyScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/27.
//

import SwiftUI

struct FilmographyScreen: View {
    @StateObject var store: Redux.LocalStore<FilmographyState>
    let actionCreator: FilmographyStateActionCreator<FilmographyState>
    
    var body: some View {
        ZStack(alignment: .top) {
            switch store.state.person {
            case .data(let person):
                ScrollView {
                    profile(person: person)
                    filmography(filmography: store.state.filmography)
                }
            case .loading:
                ProgressView()
            case .error(_):
                ProgressView()
            }
        }
        .background(Color.Background.main)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .onDidLoad {
            Task {
                await store.dispatch(actionCreator.getPerson())
                await store.dispatch(actionCreator.getFilmogry())
            }
        }
    }
    
    private func profile(person: Person) -> some View {
        ZStack {
            HStack(alignment: .top, spacing: 0.0) {
                NetworkImageView(
                    imageUrl: person.profileUrl,
                    aspectRatio: person.profileImageAspectRatio,
                    size: CGSize(width: 80, height: 80)
                )
                .cornerRadius(8.0)
                .padding(8)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text(person.name)
                        .font(.title50())
                    Text("Birthday")
                        .font(.title25())
                    Text("\(person.birthday)")
                        .font(.body45())
                    if !person.biography.isEmpty {
                        Text("Biography")
                            .font(.title25())
                        Text("\(person.biography)")
                            .font(.body45())
                    }
                }
                .padding([.vertical, .trailing], 8)
                Spacer()
            }
        }
        .background(Color.Background.main)
        .frame(maxWidth: .infinity)
        .padding(8)
    }
    
    private func filmography(filmography: AsyncValue<Filmography>) -> some View {
        ZStack(alignment: .top) {
            switch filmography {
            case .data(let filmography):
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Filmography")
                        .font(.title25())
                        .padding(.horizontal, 10)
                    LazyVStack(alignment: .leading, spacing: 0.0) {
                        ForEach(filmography.movies) { movie in
                            Button {
                                Task {
                                    await store.dispatch(RoutingStateAction.routePushed(.movieDetail(movieId: movie.id)))
                                }
                            } label: {
                                HStack(alignment: .center, spacing: 0.0) {
                                    NetworkImageView(
                                        imageUrl: movie.posterUrl,
                                        aspectRatio: movie.posterAspectRatio,
                                        size: CGSize(width: 80, height: 80)
                                    )
                                    .cornerRadius(8.0)
                                    VStack(alignment: .leading, spacing: 20.0) {
                                        Text(movie.title)
                                            .foregroundStyle(Color.Text.body)
                                            .font(.title25())
                                            .multilineTextAlignment(.leading)
                                        Text("\(movie.reviewersCount)")
                                            .foregroundStyle(Color.Text.body)
                                            .font(.bodyB50())
                                        + Text(" Reviewers")
                                            .font(.body40())
                                            .foregroundStyle(Color.Text.body)
                                    }
                                    .padding(.horizontal, 10)
                                    Spacer()
                                    ScoreView(score: movie.rate)
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .padding(10)
                        }
                    }
                    .background(Color.Background.main)
                }
            case .loading:
                ProgressView()
            case .error:
                ProgressView()
            }
        }
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: FilmographyState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    FilmographyScreen(store: store,
                      actionCreator: ActionCreatorAssembler().resolve(personId: PersonId(value: "5"), type: .cast))
        .environment(\.globalStore, globalStore)
}
