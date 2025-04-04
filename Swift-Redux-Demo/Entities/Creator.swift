//
//  Credit.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import Foundation

struct Creator: Identifiable {
    let id: String = UUID().uuidString
    let personId: PersonId
    let name: String
    let job: String
    let profilePath: String
    
    var imageAspectRatio: CGFloat {
        185 / 278
    }
    
    var imagePath: String {
        "http://image.tmdb.org/t/p/w780\(profilePath)"
    }
}
