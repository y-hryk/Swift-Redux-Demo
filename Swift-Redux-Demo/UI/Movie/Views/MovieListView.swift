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
    var scrolledToBottom: ((MovieList) -> Void)? = nil
    var body: some View {
        switch movieList {
        case .data(let moviewList):
            contents(moviewList: moviewList)
        case .error:
            CenterProgressView()
        case .loading:
            contents(moviewList: MovieList.demos(), isLoading: true)
        }
    }
    
    func contents(moviewList: MovieList, isLoading: Bool = false) -> some View {
        List {
            ForEach(moviewList.results) { movie in
                Button {
                    onPressed?(movie.id)
                } label: {
                    Row(movie: movie)
                        .onAppear {
                            if let last = moviewList.results.last, last.id == movie.id {
                                scrolledToBottom?(moviewList)
                            }
                        }
                }
                .buttonStyle(OpacityHighlightButtonStyle())
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .scrollContentBackground(.hidden)
        .redacted(reason: isLoading ? .placeholder : [])
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
                                    .font(.titleM())
                                Text(movie.releaseDateAt)
                                    .foregroundStyle(Color.Text.bodyWhite)
                                    .font(.bodyM())
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
