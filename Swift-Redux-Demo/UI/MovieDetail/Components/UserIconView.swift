//
//  UserIconView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/27.
//

import SwiftUI

struct UserIconView: View {
    let review: Review?
    var body: some View {
        if let review = review, let imageUrl = review.avatarImagePath {
            NetworkImageView(imageUrl: imageUrl, aspectRatio: 1 / 1)
                .frame(width: 30, height: 30)
                .cornerRadius(15)
        } else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .tint(Color("tint_color"))
                .cornerRadius(15)
        }
    }
}

#Preview {
    UserIconView(review: nil)
}
