//
//  MovieCreditsResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/01.
//

import Foundation

struct MovieCreditsResponse: Codable {
    let casts: [Cast]
    let crews: [Crew]
    
    enum CodingKeys: String, CodingKey {
        case casts = "cast"
        case crews = "crew"
    }
    
    struct Cast: Codable {
        let id: Int
        let castId: Int?
        let knownForDepartment: String
        let name: String
        let characterName: String?
        let profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case castId = "cast_id"
            case knownForDepartment = "known_for_department"
            case name
            case characterName = "character"
            case profilePath = "profile_path"
        }
    }
    struct Crew: Codable {
        let id: Int
        let knownForDepartment: String
        let name: String
        let job: String
        let profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case knownForDepartment = "known_for_department"
            case name
            case job
            case profilePath = "profile_path"
        }
    }
}
