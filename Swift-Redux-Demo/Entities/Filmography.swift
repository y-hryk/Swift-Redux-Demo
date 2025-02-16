//
//  Filmography.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import Foundation

enum FilmographyType {
    case cast
    case crew
}

struct Filmography {
    let type: FilmographyType
    let personId: PersonId
    let cast: [Movie]
    let crew: [Movie]
    var movies: [Movie] {
        switch type {
        case .cast: return cast
        case .crew: return crew
        }
    }
}
