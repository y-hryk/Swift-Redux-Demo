//
//  MovieListView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import SwiftUI

struct MovieListView: View {
    var movieList: AsyncValue<MovieList>
    var onPressed: ((MovieId) -> Void)? = nil
    var refreshHandler: (() async -> Void)? = nil
    var scrolledToBottom: ((MovieList) -> Void)? = nil
    
    @State private var hasScrolledToBottom = false
    @State private var hasUserInteracted = false
    
    var body: some View {
        switch movieList {
        case .data(let moviewList):
            contents(moviewList: moviewList)
        case .error:
            CenterProgressView()
        case .loading:
            contents(moviewList: MovieList.preview(), isLoading: true)
        }
    }
    
    func contents(moviewList: MovieList, isLoading: Bool = false) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(moviewList.results) { movie in
                    Button {
                        onPressed?(movie.id)
                    } label: {
                        Row(movie: movie)
                            .onAppear {
                                if let lastMovie = moviewList.results.last,
                                   lastMovie.id == movie.id,
                                   hasUserInteracted,
                                   !hasScrolledToBottom {
                                    hasScrolledToBottom = true
                                    scrolledToBottom?(moviewList)
                                }
                            }
                    }
                    .buttonStyle(OpacityHighlightButtonStyle())
                }
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged { _ in
                    hasUserInteracted = true
                }
        )
        .refreshable {
            await refreshHandler?()
        }
        .background(Color.Background.main)
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            hasScrolledToBottom = false
            hasUserInteracted = false
        }
        .onChange(of: movieList) { _, _ in
            hasScrolledToBottom = false
        }
    }
    
    struct Row: View {
        var movie: Movie
        var body: some View {
            NetworkImageView(imageUrl: movie.imagePath,
                             aspectRatio: 16 / 9)
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        gradient
                        HStack {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .foregroundStyle(Color.Text.bodyWhite)
                                    .font(.title50())
                                Text(movie.releaseDateAt)
                                    .foregroundStyle(Color.Text.bodyWhite)
                                    .font(.body50())
                            }
                            Spacer()
                            ScoreView(score: movie.rate,
                                      textColor: Color.Text.bodyWhite)
                                .frame(width: 60, height: 60)
                                
                        }
                        .padding()
                    }
                    .foregroundStyle(.white)
                }
        }
    }
}

#Preview {
    MovieListView(movieList: .loading) { _ in
        
    }
}
