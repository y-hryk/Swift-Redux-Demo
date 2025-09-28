//
//  FilmographyState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/27.
//

import Foundation

struct FilmographyState: Redux.State, Equatable {
    var personId: PersonId
    var type: FilmographyType
    var person: AsyncValue<Person>
    var filmography: AsyncValue<Filmography>
}

extension FilmographyState {
    var stateIdentifier: String {
        className + "_" + personId.value
    }
    
    init(personId: PersonId, type: FilmographyType) {
        self.personId = personId
        self.type = type
        self.person = .loading
        self.filmography = .loading
    }
    
    static func preview() -> FilmographyState {
        FilmographyState(
            personId: PersonId(value: "0"),
            type: .crew,
            person: .data(value: Person.preview()),
            filmography: .data(value: Filmography.preview())
        )
    }
}

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
