//
//  FilmographyStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import Foundation

enum FilmographyStateAction: Action {
    case didReceivePerson(AsyncValue<Person>)
    case didReceiveFilmography(AsyncValue<Filmography>)
}

struct FilmographyStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let personRepository: PersonRepository
        let personId: PersonId
        let type: FilmographyType
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getPerson() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let person = try await dependency.personRepository.getPerson(personId: dependency.personId)
                return FilmographyStateAction.didReceivePerson(.data(value: person))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
    
    func getFilmogry() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let filmogry = try await dependency.personRepository.getFilmogry(personId: dependency.personId, type: dependency.type)
                return FilmographyStateAction.didReceiveFilmography(.data(value: filmogry))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
