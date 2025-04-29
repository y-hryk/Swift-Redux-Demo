//
//  PersonRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import Foundation

protocol PersonRepository {
    func getPerson(personId: PersonId) async throws -> Person
    func getFilmogry(personId: PersonId, type: FilmographyType) async throws -> Filmography
}

struct PersonRepositoryImpl: PersonRepository, Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getPerson(personId: PersonId) async throws -> Person {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.PersonAPIs.GetPerson(personId: personId.value))
        return Person(id: PersonId(value: response.id),
                      biography: response.biography,
                      birthday: response.birthday ?? "Unidentified",
                      name: response.name,
                      profilePath: response.profilePath)
    }
    
    func getFilmogry(personId: PersonId, type: FilmographyType) async throws -> Filmography {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.PersonAPIs.GetFilmography(personId: personId.value))

        return Filmography(
            type: type, 
            personId: PersonId(value: response.id),
            cast: uniqueMovies(movies: response.cast)
                .sorted(by: { $0.rate.value > $1.rate.value }),
            crew: uniqueMovies(movies: response.crew)
                .sorted(by: { $0.rate.value > $1.rate.value })
        )
    }
    
    private func uniqueMovies(movies: [FilmographyResponse.MovieResponse]) -> [Movie] {
        Array(Dictionary(grouping: movies) { $0.id })
            .compactMap { id, value -> Movie? in
                guard let movie = value.first,
                      let backdropPath = movie.backdropPath,
                      let posterPath = movie.posterPath else { return nil }
            
                return Movie(id: MovieId(value: movie.id),
                             title: movie.title,
                             overview: movie.overview,
                             rate: UserScore(value: movie.rate),
                             reviewersCount: movie.reviewersCount,
                             backdropPath: backdropPath,
                             posterPath: posterPath,
                             releaseDateAt: movie.releaseDateAt)
            }
    }
}
