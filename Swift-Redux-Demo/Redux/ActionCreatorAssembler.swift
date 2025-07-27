//
//  ActionCreatorAssembler.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

struct ActionCreatorAssembler {
    func resolve<State: Redux.State>() -> AuthenticationStateActionCreator<State> {
        AuthenticationStateActionCreator(with: AuthenticationStateActionCreator.Dependency(
            userRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve<State: Redux.State>() -> SignInPageStateActionCreator<State> {
        SignInPageStateActionCreator(
            with: SignInPageStateActionCreator.Dependency(userRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve<State: Redux.State>() -> MaintenancePageActionCreator<State> {
        MaintenancePageActionCreator(with: MaintenancePageActionCreator.Dependency(
            maintenanceRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve<State: Redux.State>() -> MoviePageStateActionCreator<State> {
        MoviePageStateActionCreator(with: MoviePageStateActionCreator.Dependency(
            movieRepository: RepositoryAssembler().resolve())
        )
    }
    
    func resolve<State: Redux.State>(movieId: MovieId) -> MovieDetailStateActionCreator<State> {
        MovieDetailStateActionCreator(with: MovieDetailStateActionCreator.Dependency(
            movieRepository: RepositoryAssembler().resolve(),
            favoriteRepository: RepositoryAssembler().resolve(),
            movieId: movieId)
        )
    }
    
    func resolve<State: Redux.State>(personId: PersonId, type: FilmographyType) -> FilmographyStateActionCreator<State> {
        FilmographyStateActionCreator(with: FilmographyStateActionCreator.Dependency(
            personRepository: RepositoryAssembler().resolve(),
            personId: personId,
            type: type)
        )
    }
    
    func resolve<State: Redux.State>() -> FavoriteStateActionCreator<State> {
        FavoriteStateActionCreator(with: FavoriteStateActionCreator.Dependency(favoriteRepository: RepositoryAssembler().resolve()))
    }
}
