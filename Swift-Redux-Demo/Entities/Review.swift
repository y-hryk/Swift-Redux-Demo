//
//  Reviews.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/23.
//

import Foundation

struct Review: Identifiable {
    let id: String = UUID().uuidString
    let author: String
    let content: String
    let authorDetails: AuthorDetails
    let createdAt: String
    let updatedAt: String
    
    struct AuthorDetails {
        let avatarPath: String?
        let rating: Double?
    }
    
    var avatarImagePath: String? {
        if let avatarPath = authorDetails.avatarPath {
            return "http://image.tmdb.org/t/p/w200\(avatarPath)"
        }
        return nil
    }
}
