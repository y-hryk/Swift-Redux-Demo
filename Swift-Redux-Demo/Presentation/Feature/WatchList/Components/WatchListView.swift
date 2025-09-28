//
//  WatchListView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/15.
//

import SwiftUI

struct WatchListView: View {
    let movies: [MovieDetail]
    let completionHandler: ((MovieDetail) -> Void)
    var body: some View {
        if movies.isEmpty {
            Text("No contents")
        } else {
            contents(movies: movies)
        }
    }
    
    func contents(movies: [MovieDetail]) -> some View {
        List {
            ForEach(movies) { movie in
                Button {
                    completionHandler(movie)
                } label: {
                    HStack(alignment: .center, spacing: 0.0) {
                        NetworkImageView(
                            imageUrl: movie.posterUrl,
                            aspectRatio: movie.posterImageAspectRatio,
                            size: CGSize(width: 80, height: 80)
                        )
                        .cornerRadius(8.0)
                        VStack(alignment: .leading, spacing: 0.0) {
                            Text(movie.title)
                                .foregroundStyle(Color.Text.body)
                                .font(.title25())
                            Spacer().frame(height: 20)
                            Text("\(movie.reviewersCount)")
                                .foregroundStyle(Color.Text.body)
                                .font(.bodyB50())
                            + Text(" Reviewers")
                                .foregroundStyle(Color.Text.body)
                                .font(.body40())
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                        ScoreView(score: movie.rate)
                            .frame(width: 60, height: 60)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(OpacityHighlightButtonStyle())
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .padding(10)
                .background(Color.Background.main)
            }
            .onDelete { indexPath in
                
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    WatchListView(movies: []) { _ in 
        
    }
}
