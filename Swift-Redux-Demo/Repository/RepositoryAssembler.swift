//
//  RepositoryAssembler.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/31.
//

import Foundation

struct RepositoryAssembler {
    func resolve() -> MovieRepository {
        MovieRepositoryImpl(with: MovieRepositoryImpl.Dependency())
    }
    
    func resolve() -> UserRepository {
        return UserRepositoryImpl(with: UserRepositoryImpl.Dependency())
    }
    
    func resolve() -> MaintenanceRepository {
        MaintenanceRepositoryImpl()
    }
//    
//    func resolve() -> PersonRepository {
//        PersonRepositoryImpl(with: PersonRepositoryImpl.Dependency())
//    }
//    
    func resolve() -> FavoriteRepository {
        FavoriteRepositoryImpl(with: FavoriteRepositoryImpl.Dependency(dataStore: FavoriteMemoryCache.shared))
    }
}
