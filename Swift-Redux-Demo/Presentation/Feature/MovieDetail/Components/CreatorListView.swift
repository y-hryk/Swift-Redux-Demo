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
            contents(creditList: value)
        case .loading, .error:
            contents(creditList: CreditList.loading(), isLoading: true)
        }
    }
    
    private func contents(creditList: CreditList, isLoading: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text("Creator")
                .font(.title25())
            Spacer().frame(height: 10)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(creditList.creators) { creator in
                        Button {
                            handler(creator.personId)
                        } label: {
                            NetworkImageView(imageUrl: creator.imagePath, aspectRatio: creator.imageAspectRatio)
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
        .redacted(reason: isLoading ? .placeholder : [])
    }
    
    private func gradationLayer(name: String, job: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(gradient: Gradient(colors: [
                .black.opacity(0.8),
                .black.opacity(0),
            ]), startPoint: .bottom, endPoint: .center)
            Spacer()
            VStack(alignment: .leading, spacing: 0.0) {
                Text(name)
                    .foregroundStyle(Color.Text.bodyWhite)
                    .font(.bodyB25())
                Text(job)
                    .foregroundStyle(Color.Text.bodyWhite)
                    .font(.body40())
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
