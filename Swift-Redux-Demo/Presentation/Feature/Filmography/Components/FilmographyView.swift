//
//  FilmographyView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/10/02.
//

import SwiftUI

struct FilmographyView: View {
    let filmography: AsyncValue<Filmography>
    var onPressed: ((Movie) -> Void)? = nil
    var body: some View {
        switch filmography {
        case .data(let data):
            content(filmography: data)
        case .loading:
            content(filmography: Filmography.preview(), isLoading: true)
        case .error:
            content(filmography: Filmography.preview(), isLoading: true)
        }
    }
    
    private func content(filmography: Filmography, isLoading: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("Filmography")
                .font(.title25())
                .padding(.horizontal, 10)
            LazyVStack(alignment: .leading, spacing: 0.0) {
                ForEach(filmography.movies) { movie in
                    Button() {
                        onPressed?(movie)
                    } label: {
                        HStack(alignment: .center, spacing: 0.0) {
                            NetworkImageView(
                                imageUrl: movie.posterUrl,
                                aspectRatio: movie.posterAspectRatio,
                                size: CGSize(width: 80, height: 80)
                            )
                            .cornerRadius(8.0)
                            VStack(alignment: .leading, spacing: 20.0) {
                                Text(movie.title)
                                    .foregroundStyle(Color.Text.body)
                                    .font(.title25())
                                    .multilineTextAlignment(.leading)
                                Text("\(movie.reviewersCount)")
                                    .foregroundStyle(Color.Text.body)
                                    .font(.bodyB50())
                                + Text(" Reviewers")
                                    .font(.body40())
                                    .foregroundStyle(Color.Text.body)
                            }
                            .padding(.horizontal, 10)
                            Spacer()
                            ScoreView(score: movie.rate)
                                .frame(width: 60, height: 60)
                        }
                    }
                    .disabled(isLoading)
                    .padding(10)
                }
            }
            .background(Color.Background.main)
        }
        .redacted(reason: isLoading ? .placeholder : [])
    }
}

#Preview {
    FilmographyView(filmography: .loading)
}
