//
//  FavoriteRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/08.
//

import Foundation

protocol FavoriteRepository {
    func getFavorites() async throws -> [MovieDetail]
    func isFavorite(movieId: MovieId) async throws -> Bool
    func addFavorite(movie: MovieDetail) async throws -> [MovieDetail]
    func removeFavorite(movie: MovieDetail) async throws -> [MovieDetail]
}

struct FavoriteRepositoryImpl: FavoriteRepository, Injectable {
    struct Dependency {
        let dataStore: FavoriteDataStore
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getFavorites() async throws -> [MovieDetail] {
        dependency.dataStore.getMovies()
    }
    
    func isFavorite(movieId: MovieId) async throws -> Bool {
        let movies = dependency.dataStore.getMovies()
        return movies.contains { $0.id == movieId }
    }
    
    func addFavorite(movie: MovieDetail) async throws -> [MovieDetail] {
        let movies = dependency.dataStore.getMovies()
        return dependency.dataStore.set(movies: movies + [movie])
    }
    
    func removeFavorite(movie: MovieDetail) async throws -> [MovieDetail] {
        var movies = dependency.dataStore.getMovies()
        movies.removeAll(where: { $0.id ==  movie.id })
        return dependency.dataStore.set(movies: movies)
    }
    
}
