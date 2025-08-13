//
//  FilmographyStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import Foundation

enum FilmographyStateAction: Redux.Action {
    case didReceivePerson(AsyncValue<Person>)
    case didReceiveFilmography(AsyncValue<Filmography>)
}

struct FilmographyStateActionCreator<State: Redux.State> {
    @Injected(\.personRepository) private var personRepository: PersonRepository
    private let personId: PersonId
    private let filmographyType: FilmographyType
    
    init(personId: PersonId, filmographyType: FilmographyType) {
        self.personId = personId
        self.filmographyType = filmographyType
    }
    
    func getPerson() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let person = try await personRepository.getPerson(personId: personId)
                return FilmographyStateAction.didReceivePerson(.data(value: person))
            } catch let error {
                return GlobalStateAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getFilmogry() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let filmogry = try await personRepository.getFilmogry(personId: personId, type: filmographyType)
                return FilmographyStateAction.didReceiveFilmography(.data(value: filmogry))
            } catch let error {
                return GlobalStateAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
}
