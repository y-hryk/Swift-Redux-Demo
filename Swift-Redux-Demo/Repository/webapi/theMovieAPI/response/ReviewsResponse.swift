//
//  ReviewsResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/23.
//

import UIKit

struct ReviewListResponse: Codable {
    let results: [Review]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
    
    struct Review: Codable {
        let author: String
        let content: String
        let authorDetails: AuthorDetails
        let createdAt: String
        let updatedAt: String
        
        enum CodingKeys: String, CodingKey {
            case author
            case content
            case authorDetails = "author_details"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
    
    struct AuthorDetails: Codable {
        let avatarPath: String?
        let rating: Double?
        
        enum CodingKeys: String, CodingKey {
            case avatarPath
            case rating
        }
    }
}
