//
//  AboutFilmView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import SwiftUI

struct AboutFilmView: View {
    let movieDetail: MovieDetail
    let creditList: AsyncValue<CreditList>
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text("About")
                .font(.title25())
            Spacer().frame(height: 20)
            VStack(alignment: .leading, spacing: 10.0) {
                about(title: "Original Title", detail: movieDetail.originalTitle)
                about(title: "Original Language", detail: movieDetail.originalLanguage)
                about(title: "Release Date", detail: movieDetail.releaseDateAt)
                about(title: "Genres", detail: movieDetail.genres.map { $0.name }.joined(separator: ","))
                if let director = creditList.value?.director, !director.isEmpty {
                    about(title: "Director", detail: director.map { $0.name }.joined(separator: ","))
                }
                if let screenplay = creditList.value?.screenplay, !screenplay.isEmpty {
                    about(title: "Screenplay", detail: screenplay.map { $0.name }.joined(separator: ","))
                }
            }
        }
    }
    
    private func about(title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 5.0) {
            HStack {
                Text(title)
                    .font(.body40())
                Spacer()
            }
            .frame(width: 180)
            Text(detail)
                .font(.bodyB25())
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

//#Preview {
//    AboutFilmView(movieDetail: .data(value: MovieDetail(
//        id: <#T##MovieId#>,
//        title: <#T##String#>,
//        originalTitle: <#T##String#>,
//        originalLanguage: <#T##String#>,
//        overview: <#T##String#>,
//        rate: <#T##Float#>,
//        reviewersCount: <#T##Int#>,
//        backdropPath: <#T##String#>,
//        posterPath: <#T##String#>,
//        releaseDateAt: <#T##String#>,
//        genres: <#T##[Genre]#>,
//        tagline: <#T##String#>,
//        runtime: <#T##Int#>)
//    ))
//}
