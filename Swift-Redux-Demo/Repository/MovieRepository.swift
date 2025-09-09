//
//  MovieRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/31.
//

import Foundation

protocol MovieRepository {
    func getMovieTopRated(page: Int?) async throws -> MovieList
    func getMovieDetail(movieId: MovieId) async throws -> MovieDetail
    func getBackdrpos(movieId: MovieId) async throws -> [Backdrop]
    func getCreditList(movieId: MovieId) async throws -> CreditList
    func getReviews(movieId: MovieId) async throws -> ReviewList
}

struct MovieRepositoryImpl: MovieRepository, Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getMovieTopRated(page: Int?) async throws -> MovieList {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.MovieAPIs.GetMovieTopRated(page: page ?? 1))
        return MovieList(
            currentPage: response.page,
            totalPages: response.totalPages,
            results: response.results.map {
                Movie(
                    id: MovieId(value: "\($0.id)"),
                    title: $0.title,
                    overview: $0.overview,
                    rate: UserScore(value: $0.rate),
                    reviewersCount: $0.reviewersCount,
                    backdropPath: $0.backdropPath,
                    posterPath: $0.posterPath,
                    releaseDateAt: $0.releaseDateAt)
                }
        )
    }
    
    func getMovieDetail(movieId: MovieId) async throws -> MovieDetail {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.MovieAPIs.GetMovieDetail(movieId: movieId.value))
        return MovieDetail(
            id: MovieId(value: "\(response.id)"),
            title: response.title,
            originalTitle: response.originalTitle,
            originalLanguage: response.originalLanguage,
            overview: response.overview,
            rate: UserScore(value: response.rate),
            reviewersCount: response.reviewersCount,
            backdropPath: response.backdropPath,
            posterPath: response.posterPath,
            releaseDateAt: response.releaseDateAt,
            genres: response.genres.map {
                Genre(id: GenreId(value: "\($0.id)"), name: $0.name)
            },
            tagline: response.tagline,
            runtime: response.runtime
        )
    }
    
    func getBackdrpos(movieId: MovieId) async throws -> [Backdrop] {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.MovieAPIs.GetImages(movieId: movieId.value))
        return response.backdrops.map {
            Backdrop(
                id: UUID().uuidString,
                filePath: $0.filePath,
                aspectRatio: $0.aspectRatio)
        }
    }
    
    func getCreditList(movieId: MovieId) async throws -> CreditList {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.MovieAPIs.GetCasts(movieId: movieId.value))
        var directors = [Creator]()
        var screenplay = [Creator]()
        let crews = Array(Dictionary(grouping: response.crews) { $0.id })
            .compactMap { id, value -> Creator? in
                guard let creator = value.first,
                      let profilePath = creator.profilePath else { return nil }
                
                let newCreator = Creator(personId: PersonId(value: "\(id)"),
                                         name: creator.name,
                                         job: value.map { $0.job }.joined(separator: ", "),
                                         profilePath: profilePath)
                
                if value.map({ $0.job.lowercased() }).contains("director") {
                    directors.append(newCreator)
                    return nil
                }
                if value.map({ $0.job.lowercased() }).contains("screenplay") {
                    screenplay.append(newCreator)
                    return nil
                }
                return newCreator
            }
        
        return CreditList(
            actors: response.casts
                .compactMap { actor -> Actor? in
                    guard let castId = actor.castId else { return nil }
                    guard let characterName = actor.characterName else { return nil }
                    guard let profilePath = actor.profilePath else { return nil }
                    return Actor(
                        id: PersonId(value: "\(actor.id)"),
                        castId: castId,
                        name: actor.name,
                        characterName: characterName,
                        profilePath: profilePath
                    )
                },
            director: directors,
            screenplay: screenplay,
            creators: directors + screenplay + crews
        )
    }
    
    func getReviews(movieId: MovieId) async throws -> ReviewList {
        let response = try await TheMoviebdAPIClient.send(TheMoviebd.MovieAPIs.GetReviews(movieId: movieId.value))
        return ReviewList(
            currentPage: response.page,
            totalPages: response.totalPages,
            results: response.results.map {
                Review(author: $0.author,
                       content: $0.content,
                       authorDetails: Review.AuthorDetails(
                            avatarPath: $0.authorDetails.avatarPath,
                            rating: $0.authorDetails.rating
                        ),
                       createdAt: $0.createdAt,
                       updatedAt: $0.updatedAt)
            }
        )
    }
    
}
