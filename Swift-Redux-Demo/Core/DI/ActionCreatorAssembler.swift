//
//  ActionCreatorAssembler.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

struct ActionCreatorAssembler {
    func resolve<State: Redux.State>() -> AuthenticationStateActionCreator<State> {
        AuthenticationStateActionCreator<State>()
    }
    
    func resolve<State: Redux.State>() -> SignInStateActionCreator<State> {
        SignInStateActionCreator<State>()
    }
    
    func resolve<State: Redux.State>() -> MaintenanceActionCreator<State> {
        MaintenanceActionCreator<State>()
    }
    
    func resolve<State: Redux.State>() -> MovieListStateActionCreator<State> {
        MovieListStateActionCreator<State>()
    }
    
    func resolve<State: Redux.State>(movieId: MovieId) -> MovieDetailStateActionCreator<State> {
        MovieDetailStateActionCreator<State>(movieId: movieId)
    }
    
    func resolve<State: Redux.State>(personId: PersonId, type: FilmographyType) -> FilmographyStateActionCreator<State> {
        FilmographyStateActionCreator<State>(personId: personId, filmographyType: type)
    }
    
    func resolve<State: Redux.State>() -> DeepLinkStateActionCreator<State> {
        DeepLinkStateActionCreator()
    }
}
