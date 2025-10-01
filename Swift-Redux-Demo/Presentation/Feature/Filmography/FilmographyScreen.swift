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
        content(person: store.state.person)
            .onDidLoad {
                Task { await store.dispatch(actionCreator.getPerson()) }
            }
    }
    
    @ViewBuilder
    private func content(person: AsyncValue<Person>) -> some View {
        switch person {
        case .data, .loading:
            ScrollView {
                PersonView(person: person)
                FilmographyView(filmography: store.state.filmography) { movie in
                    Task {
                        await store.dispatch(RoutingStateAction.routePushed(.movieDetail(movieId: movie.id)))
                    }
                }
            }
            .background(Color.Background.main)
            .onDidLoad {
                Task {
                    await store.dispatch(actionCreator.getFilmogry())
                }
            }
        case .error:
            ErrorView() {
                Task {
                    await store.dispatch(actionCreator.getPerson())
                }
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
