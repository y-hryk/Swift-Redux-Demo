//
//  FilmographyStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import Foundation

extension FilmographyState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        switch action {
        case FilmographyStateAction.didReceivePerson(let person):
            state.person = person
        case FilmographyStateAction.didReceiveFilmography(let filmography):
            state.filmography = filmography
        default: break
        }
        return state
    }
}
