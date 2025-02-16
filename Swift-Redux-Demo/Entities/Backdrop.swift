//
//  Backdrop.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/01.
//

import Foundation

struct Backdrop: Identifiable {
    let id: String
    let filePath: String
    let aspectRatio: Double
    
    var imagePath: String {
        "http://image.tmdb.org/t/p/w780\(filePath)"
    }
    
    static func demos() -> [Backdrop] {
        [
            Backdrop(id: UUID().uuidString, filePath: "/6rle7VkpIgH0hk2xHIZKEAUkOW1.jpg", aspectRatio: 0.667),
            Backdrop(id: UUID().uuidString, filePath: "/6rle7VkpIgH0hk2xHIZKEAUkOW1.jpg", aspectRatio: 0.667),
            Backdrop(id: UUID().uuidString, filePath: "/6rle7VkpIgH0hk2xHIZKEAUkOW1.jpg", aspectRatio: 0.667),
            Backdrop(id: UUID().uuidString, filePath: "/6rle7VkpIgH0hk2xHIZKEAUkOW1.jpg", aspectRatio: 0.667)
        ]
    }
}

