//
//  MovieDetailScrollView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/03/30.
//

import SwiftUI

struct MovieDetailScrollView<Content: View>: View {
    let movieDetail: AsyncValue<MovieDetail>
    let colorScheme: ColorScheme
    let content: (_ movieDetail: MovieDetail) -> Content
    
    @State var imageOverlayOpacity: CGFloat = 0
    @State var imageOffset: CGFloat = 0
    @State var navigationBarOpacity: CGFloat = 0
    
    public init(
        movieDetail: AsyncValue<MovieDetail>,
        colorScheme: ColorScheme,
        @ViewBuilder content: @escaping (_ movieDetail: MovieDetail) -> Content
    ) {
        self.movieDetail = movieDetail
        self.colorScheme = colorScheme
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometory in
            ZStack(alignment: .top) {
                ZStack(alignment: .top) {
                    switch movieDetail {
                    case .data(let movieDetail):
                        content(movieDetail: movieDetail, safeAreaInsetsTop: geometory.safeAreaInsets.top)
                    case .loading:
                        content(movieDetail: MovieDetail.loading(), safeAreaInsetsTop: geometory.safeAreaInsets.top, isLoading: true)
                    case .error(_):
                        content(movieDetail: MovieDetail.loading(), safeAreaInsetsTop: geometory.safeAreaInsets.top, isLoading: true)
                    }
                    if #unavailable(iOS 26) {
                        navigationBar(height: geometory.safeAreaInsets.top)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color.Background.main)
        }
    }
    
    func content(movieDetail: MovieDetail, safeAreaInsetsTop: CGFloat, isLoading: Bool = false) -> some View {
        OffsetReadableScrollView(onChangeOffset: { offset in
            let height = UIScreen.main.bounds.width / movieDetail.posterImageAspectRatio
            self.imageOverlayOpacity = -offset.y / height
            self.imageOffset = min(-offset.y / 3.0, -offset.y)
            self.navigationBarOpacity = min(CGFloat(-offset.y / (height - safeAreaInsetsTop)), 1.0)
        }) {
            heaerImage(movieDetail: movieDetail, isLoading: isLoading)
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.Background.main.opacity(0.1) : Color.Background.main,
                    Color.Background.main
                ]), startPoint: .top, endPoint: .bottom)
                content(movieDetail)
                    .redacted(reason: isLoading ? .placeholder : [])
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(colorScheme == .dark ? 0.0 : 20.0)
            .padding(.top, colorScheme == .dark ? -160 : -30)
        }
        .ignoresSafeArea(edges: [.top])
    }
    
    func heaerImage(movieDetail: MovieDetail, isLoading: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            NetworkImageView(imageUrl: movieDetail.posterUrl,
                             aspectRatio: movieDetail.posterImageAspectRatio)
            .offset(y: imageOffset)
            Rectangle()
                .fill(Color.Background.main
                    .opacity(colorScheme == .dark ? (imageOverlayOpacity + 0.4) : imageOverlayOpacity))
                .offset(y: imageOffset)
        }
    }
    
    func navigationBar(height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.Background.main.opacity(navigationBarOpacity + 0.4))
                .frame(height: height)
        }
        .ignoresSafeArea()
    }
}

//#Preview {
//    MovieDetailScrollView()
//}
