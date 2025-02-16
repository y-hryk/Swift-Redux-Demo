//
//  FilmographyResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import Foundation

struct FilmographyResponse: Codable {
    let id: Int
    let cast: [MovieResponse]
    let crew: [MovieResponse]
    
    struct MovieResponse: Codable {
        let id: Int
        let title: String
        let overview: String
        let rate: Float
        let reviewersCount: Int
        let backdropPath: String?
        let posterPath: String?
        let releaseDateAt: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case overview
            case rate = "vote_average"
            case reviewersCount = "vote_count"
            case backdropPath = "backdrop_path"
            case posterPath = "poster_path"
            case releaseDateAt = "release_date"
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<FilmographyResponse.MovieResponse.CodingKeys> = try decoder.container(keyedBy: FilmographyResponse.MovieResponse.CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.id)
            self.title = try container.decode(String.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.title)
            self.overview = try container.decode(String.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.overview)
            self.rate = (try? container.decode(Float.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.rate)) ?? 0.0
            self.reviewersCount = (try? container.decode(Int.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.reviewersCount)) ?? 0
            self.backdropPath = try container.decodeIfPresent(String.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.backdropPath)
            self.posterPath = try container.decodeIfPresent(String.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.posterPath)
            self.releaseDateAt = (try? container.decode(String.self, forKey: FilmographyResponse.MovieResponse.CodingKeys.releaseDateAt)) ?? ""
        }
    }
}
