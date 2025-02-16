//
//  BackdropView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/24.
//

import SwiftUI

struct BackdropView: View {
    var backdrops: AsyncValue<[Backdrop]>
    var body: some View {
        VStack(alignment: .leading) {
            switch backdrops {
            case .data(let value):
                contents(backdrops: value)
            case .loading, .error:
                contents(backdrops: Backdrop.demos(), isLoading: true)
            }
        }
    }
    
    private func contents(backdrops: [Backdrop], isLoading: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text("Backdrops")
                .font(.subTitleL())
            Spacer().frame(height: 10)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(backdrops) {
                        NetworkImageView(imageUrl: $0.imagePath, aspectRatio: $0.aspectRatio)
                    }
                }
            }
            .frame(height: 140)
        }
        .redacted(reason: isLoading ? .placeholder : [])
    }
}

#Preview {
    BackdropView(backdrops: .loading)
}
