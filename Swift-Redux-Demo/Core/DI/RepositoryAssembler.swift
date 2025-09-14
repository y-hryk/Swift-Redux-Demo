//
//  RepositoryAssembler.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/31.
//

import Foundation

// MovieRepository
private struct MovieRepositoryKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: MovieRepository = MovieRepositoryImpl(with: MovieRepositoryImpl.Dependency())
}

extension InjectedValues {
    var movieRepository: MovieRepository {
        get { Self[MovieRepositoryKey.self] }
        set { Self[MovieRepositoryKey.self] = newValue }
    }
}

// UserRepository
private struct UserRepositoryKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: UserRepository = UserRepositoryImpl(with: UserRepositoryImpl.Dependency())
}

extension InjectedValues {
    var userRepository: UserRepository {
        get { Self[UserRepositoryKey.self] }
        set { Self[UserRepositoryKey.self] = newValue }
    }
}

// MaintenanceRepository
private struct MaintenanceRepositoryKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: MaintenanceRepository = MaintenanceRepositoryImpl()
}

extension InjectedValues {
    var maintenanceRepository: MaintenanceRepository {
        get { Self[MaintenanceRepositoryKey.self] }
        set { Self[MaintenanceRepositoryKey.self] = newValue }
    }
}

// PersonRepository
private struct PersonRepositoryKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: PersonRepository = PersonRepositoryImpl(with: PersonRepositoryImpl.Dependency())
}

extension InjectedValues {
    var personRepository: PersonRepository {
        get { Self[PersonRepositoryKey.self] }
        set { Self[PersonRepositoryKey.self] = newValue }
    }
}
