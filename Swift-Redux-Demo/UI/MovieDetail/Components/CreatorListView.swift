//
//  CreatorListView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import SwiftUI

struct CreatorListView: View {
    var creditList: AsyncValue<CreditList>
    let handler: (PersonId) -> Void
    var body: some View {
        switch creditList {
        case .data(let value):
            if value.creators.isEmpty {
                EmptyView()
            } else {
                Text("Creator")
                    .font(.subTitleL())
                Spacer().frame(height: 10)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(value.creators) { creator in
                            Button {
                                handler(creator.personId)
                            } label: {
                                NetworkImageView(imageUrl: creator.imagePath, aspectRatio: 185 / 278)
                            }
                            .overlay {
                                gradationLayer(name: creator.name, job: creator.job)
                            }
                            .cornerRadius(8)
                        }
                    }
                }
                .frame(height: 180)
            }
        case .loading, .error:
            ProgressView()
        }
    }
    
    private func gradationLayer(name: String, job: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(gradient: Gradient(colors: [
                .black.opacity(0.8),
                .black.opacity(0),
            ]), startPoint: .bottom, endPoint: .center)
            Spacer()
            VStack(alignment: .leading, spacing: 0.0) {
                Text(name)                                    .foregroundStyle(Color.Text.bodyWhite)
                    .font(.captionL())
                Text(job)                                    .foregroundStyle(Color.Text.bodyWhite)
                    .font(.captionS())
            }
            .padding(6)
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    CastListView(creditList: .loading) { _ in
        
    }
}
