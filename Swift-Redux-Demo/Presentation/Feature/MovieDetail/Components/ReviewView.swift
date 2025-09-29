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
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Reviews")
                        .font(.title25())
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 10.0) {
                            UserIconView(review: review)
                            Text(review.author)
                                .foregroundStyle(Color.Text.body)
                                .font(.body50())
                            Spacer()
                        }
                        Text(review.content)
                            .foregroundStyle(Color.Text.body)
                            .font(.body50())
                    }
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
