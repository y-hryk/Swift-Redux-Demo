//
//  Actor.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/01.
//

import Foundation

struct Actor: Identifiable, Equatable {
    let id: PersonId
    let castId: Int
    let name: String
    let characterName: String
    let profilePath: String
    
    var imagePath: String {
        "http://image.tmdb.org/t/p/w780\(profilePath)"
    }
    
    var imageAspectRatio: CGFloat {
        185 / 278
    }
    
    static func demos() -> [Actor] {
        [
            Actor(
                id: PersonId(value: 1),
                castId: 123,
                name: "name",
                characterName: "characterName",
                profilePath: "/7YkPrZLjVVOTQNXAgxgjzGRrzsP.jpg"
            )
        ]
    }
}
