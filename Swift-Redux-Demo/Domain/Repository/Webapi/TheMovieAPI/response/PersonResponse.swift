//
//  PersonResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/30.
//

import Foundation

struct PersonResponse: Codable {
    let id: Int
    let biography: String
    let birthday: String?
    let name: String
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case biography
        case birthday
        case name
        case profilePath = "profile_path"
    }
}
