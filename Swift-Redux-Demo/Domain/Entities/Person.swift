//
//  Person.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/30.
//

import Foundation

struct Person: Equatable {
    let id: PersonId
    let biography: String
    let birthday: String
    let name: String
    let profilePath: String
    
    var profileUrl: String {
        "http://image.tmdb.org/t/p/w780\(profilePath)"
    }
    
    var profileImageAspectRatio: CGFloat {
        780 / 1112
    }
    
    static func preview() -> Person {
        Person(
            id: PersonId(value: "7467"),
            biography: "xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx",
            birthday: "1962-08-28",
            name: "David Fincher",
            profilePath: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg"
        )
    }
}
