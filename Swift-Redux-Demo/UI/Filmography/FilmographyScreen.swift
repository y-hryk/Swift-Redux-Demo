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
            case .error(let _):
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
                        .font(.titleM())
                    Text("Birthday")
                        .font(.subTitleL())
                    Text("\(person.birthday)")
                        .font(.bodyS())
                    if !person.biography.isEmpty {
                        Text("Biography")
                            .font(.subTitleL())
                        Text("\(person.biography)")
                            .font(.bodyS())
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
                VStack(alignment: .leading, spacing: 0.0) {
                    Spacer().frame(height: 10)
                    Text("Filmography")
                        .font(.subTitleL())
                        .padding(.horizontal, 10)
                    Spacer().frame(height: 10)
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
                                    VStack(alignment: .leading, spacing: 0.0) {
                                        Text(movie.title)
                                            .foregroundStyle(Color.Text.body)
                                            .font(.subTitleL())
                                            .multilineTextAlignment(.leading)
                                        Spacer().frame(height: 20)
                                        Text("\(movie.reviewersCount)")
                                            .foregroundStyle(Color.Text.body)
                                            .font(.subTitleM())
                                        + Text(" Reviewers")
                                            .font(.captionS())
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
            case .error(let error):
                ProgressView()
            }
        }
    }
}

//#Preview {
//    FilmographyContentView(personId: PersonId(value: 287), type: .cast)
//        .environmentObject(store)
//}
