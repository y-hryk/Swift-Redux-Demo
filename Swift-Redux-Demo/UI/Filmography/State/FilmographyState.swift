//
//  FilmographyState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/27.
//

import Foundation

struct FilmographyState: Redux.State {
    var personId: PersonId
    var type: FilmographyType
    var person: AsyncValue<Person>
    var filmography: AsyncValue<Filmography>
}

extension FilmographyState {
    var stateIdentifier: String {
        className + "_" + personId.value
    }
    
    init() {
        self.personId = PersonId(value: 0)
        self.type = .cast
        self.person = .loading
        self.filmography = .loading
    }
    
    init(personId: PersonId, type: FilmographyType) {
        self.personId = personId
        self.type = type
        self.person = .loading
        self.filmography = .loading
    }
}
