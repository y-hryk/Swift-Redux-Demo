//
//  FavoriteMemoryCache.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/08.
//

import Foundation

protocol FavoriteDataStore {
    func getMovies() -> [MovieDetail]
    func set(movies: [MovieDetail]) -> [MovieDetail]
}

class FavoriteMemoryCache: FavoriteDataStore {
    static let shared = FavoriteMemoryCache()
    private var movies = [MovieDetail]()
    
    func getMovies() -> [MovieDetail] {
        movies
    }
    
    func set(movies: [MovieDetail]) -> [MovieDetail] {
        self.movies = movies
        return movies
    }
}
