//
//  RoutingPath.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/17.
//

import SwiftUI

enum RoutingPath: Equatable, Hashable {
    // root
    case splash
    case maintenance
    case signedIn
    case signedOut
    // tab root
    case movieList
    case watchList
    case debug
    // other
    case filmography(personId: PersonId, type: FilmographyType)
    case movieDetail(movieId: MovieId)
    case debugFirstModel
    case debugSecondModal
    
    @MainActor @ViewBuilder
    func destination() -> some View {
        switch self {
        case .splash:
            let store = LocalStoreBuilder
                .default(initialState: SplashPageState())
                .build()
            SplashScreen(
                store: store,
                actionCreator: ActionCreatorAssembler().resolve()
            )
        case .maintenance:
            let store = LocalStoreBuilder
                .default(initialState: MaintenancePageState())
                .build()
            MaintenanceScreen(
                store: store,
                maintenanceActionCreator: ActionCreatorAssembler().resolve()
            )
        case .signedIn:
            let store = LocalStoreBuilder
                .default(initialState: TabState())
                .build()
            TabScreen(
                store: store
            )
        case .signedOut:
            let store = LocalStoreBuilder
                .default(initialState: SignInPageState())
                .build()
            SignInScreen(
                store: store,
                actionCreator: ActionCreatorAssembler().resolve()
            )
        case .movieList:
            let store = LocalStoreBuilder
                .default(initialState: MoviePageState())
                .build()
            MovieListScreen(
                store: store,
                actionCreator: ActionCreatorAssembler().resolve()
            )
        case .watchList:
            let store = LocalStoreBuilder
                .default(initialState: WatchListPageState())
                .build()
            WatchListScreen(
                store: store
            )
        case .debug:
            let store = LocalStoreBuilder
                .default(initialState: DebugPageState())
                .build()
            DebugScreen(
                store: store
            )
        case .filmography(let personId, let type):
            let store = LocalStoreBuilder
                .default(initialState: FilmographyState(personId: personId, type: type))
                .build()
            FilmographyScreen(
                store: store,
                actionCreator: ActionCreatorAssembler().resolve(personId: personId, type: type)
            )
        case .movieDetail(let movieId):
            let store = LocalStoreBuilder
                .default(initialState: MovieDetailState.fromId(movieId: movieId))
                .build()
            MovieDetailScreen(
                store: store,
                movieDetailStateActionCreator: ActionCreatorAssembler().resolve(movieId: movieId)
            )
        case .debugFirstModel:
            let store = LocalStoreBuilder
                .default(initialState: DebugModalState())
                .build()
            DebugFirstModalScreen(
                store: store
            )
        case .debugSecondModal:
            let store = LocalStoreBuilder
                .default(initialState: DebugModalState())
                .build()
            DebugSecondModalScreen(
                store: store
            )
        }
    }
}
