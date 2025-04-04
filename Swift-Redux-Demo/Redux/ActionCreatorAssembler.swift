//
//  ActionCreatorAssembler.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

struct ActionCreatorAssembler {
    func resolve() -> AuthenticationStateActionCreator<AppState> {
        AuthenticationStateActionCreator(with: AuthenticationStateActionCreator.Dependency(
            userRepository: RepositoryAssembler().resolve())
        )
    }
    
//    func resolve() -> RoutingStateActionCreator {
//        RoutingStateActionCreator(with: RoutingStateActionCreator.Dependency(
//            userRepository: RepositoryAssembler().resolve())
//        )
//    }
//    
    func resolve() -> SignInPageStateActionCreator<AppState> {
        SignInPageStateActionCreator(
            with: SignInPageStateActionCreator.Dependency(userRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve() -> MaintenancePageStateActionCreator<AppState> {
        MaintenancePageStateActionCreator(with: MaintenancePageStateActionCreator.Dependency(
            maintenanceRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve() -> MoviePageStateActionCreator<AppState> {
        MoviePageStateActionCreator(with: MoviePageStateActionCreator.Dependency(
            movieRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve(movieId: MovieId) -> MovieDetailStateActionCreator<AppState> {
        MovieDetailStateActionCreator(with: MovieDetailStateActionCreator.Dependency(
            movieRepository: RepositoryAssembler().resolve(),
            favoriteRepository: RepositoryAssembler().resolve(),
            movieId: movieId)
        )
    }
//    
//    func resolve(personId: PersonId, type: FilmographyType) -> FilmographyStateActionCreator {
//        FilmographyStateActionCreator(with: FilmographyStateActionCreator.Dependency(
//            personRepository: RepositoryAssembler().resolve(),
//            personId: personId,
//            type: type)
//        )
//    }
//    
    func resolve() -> WatchListStateActionCreator<AppState> {
        WatchListStateActionCreator(with: WatchListStateActionCreator.Dependency(favoriteRepository: RepositoryAssembler().resolve()))
    }
}
