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
}
