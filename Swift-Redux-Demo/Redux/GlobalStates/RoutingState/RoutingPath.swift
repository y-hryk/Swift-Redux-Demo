//
//  RoutingPath.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/17.
//

import SwiftUI

enum RoutingPath: Hashable {
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
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .splash:
            let store = LocalStoreBuilder.create(initialState: SplashPageState(), reducer: SplashPageState.reducer)
            SplashScreen(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .maintenance:
            let store = LocalStoreBuilder.create(initialState: MaintenancePageState(), reducer: MaintenancePageState.reducer)
            MaintenanceScreen(store: store,
                              maintenanceActionCreator: ActionCreatorAssembler().resolve())
            
        case .signedIn:
            let store = LocalStoreBuilder.create(initialState: TabState(), reducer: TabState.reducer)
            TabScreen(store: store)

        case .signedOut:
            let store = LocalStoreBuilder.create(initialState: SignInPageState(), reducer: SignInPageState.reducer)
            SignInScreen(store: store,
                         actionCreator: ActionCreatorAssembler().resolve())
            
        case .movieList:
            let store = LocalStoreBuilder.create(initialState: MoviePageState(), reducer: MoviePageState.reducer)
            MovieListScreen(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .watchList:
            let store = LocalStoreBuilder.create(initialState: WatchListPageState(), reducer: WatchListPageState.reducer)
            WatchListContentView(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .debug:
            let store = LocalStoreBuilder.create(initialState: DebugPageState(), reducer: DebugPageState.reducer)
            DebugScreen(store: store)
            
        case .filmography(let personId, let type):
            let store = LocalStoreBuilder.create(initialState: FilmographyState(), reducer: FilmographyState.reducer)
            FilmographyScreen(store: store,
                              actionCreator: ActionCreatorAssembler().resolve(personId: personId, type: type))
        
        case .movieDetail(let movieId):
            let store = LocalStoreBuilder.create(
                initialState: MovieDetailState.fromId(movieId: movieId),
                reducer: MovieDetailState.reducer
            )
            MovieDetailScreen(store: store,
                              movieDetailStateActionCreator: ActionCreatorAssembler().resolve(movieId: movieId),
                              favoriteStateActionCreator: ActionCreatorAssembler().resolve())
        case .debugFirstModel:
            let store = LocalStoreBuilder.create(
                initialState: EmptyState(),
                reducer: EmptyState.reducer
            )
            DebugFirstModalScreen(store: store)
            
        case .debugSecondModal:
            let store = LocalStoreBuilder.create(
                initialState: EmptyState(),
                reducer: EmptyState.reducer
            )
            DebugSecondModalScreen(store: store)
        }
    }
}
