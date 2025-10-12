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
            SplashScreen(
                state: SplashState(),
                actionCreator: AuthenticationStateActionCreator()
            )
        case .maintenance:
            MaintenanceScreen(
                state: MaintenanceState(),
                actionCreator: MaintenanceActionCreator()
            )
        case .signedIn:
            TabScreen(
                state: TabState()
            )
        case .signedOut:
            SignInScreen(
                state: SignInState(),
                actionCreator: SignInStateActionCreator()
            )
        case .movieList:
            MovieListScreen(
                state:  MovieListState(),
                actionCreator: MovieListStateActionCreator()
            )
        case .watchList:
            WatchListScreen(
                state: WatchListState()
            )
        case .debug:
            DebugScreen(
                state: DebugState(),
                actionCreator: DebugStateActionCreator()
            )
        case .filmography(let personId, let type):
            FilmographyScreen(
                state: FilmographyState(personId: personId, type: type),
                actionCreator: FilmographyStateActionCreator(personId: personId, filmographyType: type)
            )
        case .movieDetail(let movieId):
            MovieDetailScreen(
                state: MovieDetailState.fromId(movieId: movieId),
                actionCreator: MovieDetailStateActionCreator(movieId: movieId)
            )
        case .debugFirstModel:
            DebugFirstModalScreen(
                state: DebugModalState()
            )
        case .debugSecondModal:
            DebugSecondModalScreen(
                state: DebugModalState()
            )
        }
    }
}
