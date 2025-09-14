//
//  PersonAPIs.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import Foundation

extension TheMoviebd {
    enum PersonAPIs {
        struct GetPerson: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = PersonResponse
            var method: HTTPMethod { .get }
            var path: String { "/person/\(personId)" }
            var parameters: [String : String]? {
                [
//                    "language": NSLocale.localeString()
                    :
                ]
            }
            let personId: String
        }
        
        struct GetFilmography: TheMoviebdAPIRequestProtocol {
            typealias ResponseType = FilmographyResponse
            var method: HTTPMethod { .get }
            var path: String { "/person/\(personId)/movie_credits" }
            var parameters: [String : String]? {
                [
                    "language": NSLocale.localeString()
//                    :
                ]
            }
            let personId: String
        }
    }
}
