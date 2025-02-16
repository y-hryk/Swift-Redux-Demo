//
//  ReviewView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/24.
//

import SwiftUI

struct ReviewView: View {
    var reviews: AsyncValue<ReviewList>
    var body: some View {
        switch reviews {
        case .data(let value):
            if let review = value.latestReview {
                Text("Reviews")
                    .font(.subTitleL())
                Spacer().frame(height: 10)
                VStack(alignment: .leading, spacing: 0.0) {
                    HStack(alignment: .center, spacing: 0.0) {
                        UserIconView(review: review)
                        Spacer().frame(width: 10.0)
                        Text(review.author)
                            .foregroundStyle(Color.Text.body)
                            .font(.bodyM())
                        Spacer()
                    }
                    Spacer().frame(height: 10)
                    Text(review.content)
                        .foregroundStyle(Color.Text.body)
                        .font(.bodyM())
                }
            } else {
                EmptyView()
            }
        case .loading, .error:
            ProgressView()
        }
    }
}

#Preview {
    ReviewView(reviews: .loading)
}
