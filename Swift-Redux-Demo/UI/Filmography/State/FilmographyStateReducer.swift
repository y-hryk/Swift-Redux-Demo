//
//  FilmographyStateReducer.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import Foundation

extension FilmographyState {
    static let reducer: Reducer<Self> = { state, actionContainer in
        var state = state
        switch actionContainer.action {
        case FilmographyStateAction.didReceivePerson(let person):
            state.person = person
        case FilmographyStateAction.didReceiveFilmography(let filmography):
            state.filmography = filmography
        default: break
        }
        return state
    }
}
