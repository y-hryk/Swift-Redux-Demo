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
    case movieDetail(movieId: MovieId)
    case debugFirstModel
    case debugSecondModal
//    case filmography(personId: PersonId, type: FilmographyType)
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .splash:
            let store = LocalStoreBuilder.create(initialState: SplashPageState(), reducer: SplashPageState.reducer)
            SplashScreen(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .maintenance:
            let store = LocalStoreBuilder.create(initialState: MaintenancePageState(), reducer: MaintenancePageState.reducer)
            MaintenancePage(store: store,
                            maintenanceActionCreator: ActionCreatorAssembler().resolve())
            
        case .signedIn:
            let store = LocalStoreBuilder.create(initialState: TabState(), reducer: TabState.reducer)
            TabScreen(store: store)

        case .signedOut:
            let store = LocalStoreBuilder.create(initialState: SignInPageState(), reducer: SignInPageState.reducer)
            SignInContentView(store: store,
                              actionCreator: ActionCreatorAssembler().resolve())
            
        case .movieList:
            let store = LocalStoreBuilder.create(initialState: MoviePageState(), reducer: MoviePageState.reducer)
            MovieListContentView(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .watchList:
            let store = LocalStoreBuilder.create(initialState: WatchListPageState(), reducer: WatchListPageState.reducer)
            WatchListContentView(store: store, actionCreator: ActionCreatorAssembler().resolve())
            
        case .debug:
            let store = LocalStoreBuilder.create(initialState: DebugPageState(), reducer: DebugPageState.reducer)
            DebugPage(store: store)
        
        case .movieDetail(let movieId):
            let store = LocalStoreBuilder.create(
                initialState: MovieDetailState.fromId(movieId: movieId),
                reducer: MovieDetailState.reducer
            )
            MovieDetailContentView(store: store,
                                   movieDetailStateActionCreator: ActionCreatorAssembler().resolve(movieId: movieId),
                                   favoriteStateActionCreator: ActionCreatorAssembler().resolve())
        case .debugFirstModel:
            let store = LocalStoreBuilder.create(
                initialState: EmptyState(),
                reducer: EmptyState.reducer
            )
            DebugFirstModalPage(store: store)
            
        case .debugSecondModal:
            let store = LocalStoreBuilder.create(
                initialState: EmptyState(),
                reducer: EmptyState.reducer
            )
            DebugSecondModalPage(store: store)
        }
    }
}

//struct FullScreenCoverView<Content: View>: View {
//    @EnvironmentObject private var appEnvironment: AppEnvironment
//
//    @Binding var currentItem: FullScreenCoverItem?
//    @State private var nextItem: FullScreenCoverItem?
//    
//    let content: () -> Content
//    
//    var body: some View {
//        content()
//            .onReceive(appEnvironment.fullScreenCoverItemTrigger) { item in
//                if nextItem == nil {
//                    nextItem = item
//                }
//            }
//            .fullScreenCover(item: $nextItem) { item in
//                item.buildView(with: $nextItem)
//            }
//    }
//}

//enum RoutingPath: Hashable {
//    // root
//    case splash
//    case maintenance
//    
//    @ViewBuilder
//    func destination() -> some View {
//        switch self {
//        case .splash:
//            let store = LocalStoreBuilder.create(initialState: SplashPageState(), reducer: SplashPageState.reducer)
//            SplashScreen(store: store, actionCreator: ActionCreatorAssembler().resolve())
//            
//        case .maintenance:
//            let store = LocalStoreBuilder.create(initialState: MaintenancePageState(), reducer: MaintenancePageState.reducer)
//            MaintenancePage(store: store,
//                            maintenanceActionCreator: ActionCreatorAssembler().resolve())
//        }
//    }
//}
