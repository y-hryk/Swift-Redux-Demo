//
//  MovieImageResponse.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/31.
//

import Foundation

struct MovieImageResponse: Codable {
    let backdrops: [BackdropReponse]

    struct BackdropReponse: Codable {
        let filePath: String
        let aspectRatio: Double
        
        enum CodingKeys: String, CodingKey {
            case filePath = "file_path"
            case aspectRatio = "aspect_ratio"
        }
    }
}
