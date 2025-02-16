//
//  NetworkImageView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/01.
//

import SwiftUI

struct NetworkImageView: View {
    let imageUrl: String
    let aspectRatio: CGFloat?
    let size: CGSize?
    
    init(imageUrl: String, aspectRatio: CGFloat?, size: CGSize? = nil) {
        self.imageUrl = imageUrl
        self.aspectRatio = aspectRatio
        self.size = size
    }
    
    static func height() -> CGFloat {
        (UIScreen.main.bounds.width * 1112) / 780
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl),
                   transaction: .init(animation: .easeOut)
        ) { phase in
            if let image = phase.image {
                if let size = size {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                } else {
                    image.resizable()
                        .aspectRatio(aspectRatio, contentMode: .fill)
                }
            } else {
                if let size = size {
                    Color.Background.main
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            ProgressView()
                        }
                } else {
                    Color.Background.main
                        .aspectRatio(aspectRatio, contentMode: .fill)
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
    }
}

#Preview {
    NetworkImageView(
        imageUrl: "http://image.tmdb.org/t/p/w780/6rle7VkpIgH0hk2xHIZKEAUkOW1.jpg",
    aspectRatio: 0.667)
}
