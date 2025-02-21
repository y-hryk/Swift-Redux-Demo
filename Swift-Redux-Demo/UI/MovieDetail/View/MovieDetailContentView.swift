//
//  MovieDetailContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/13.
//

import SwiftUI

struct MovieDetailContentView: View {   
    @EnvironmentObject var store: ReduxStore<AppState>
    @Environment(\.colorScheme) var colorScheme
    let actionCreator: MovieDetailStateActionCreator<AppState>
    let initalState: MovieDetailState

    var state: MovieDetailState {
        store.state.routingState.mapState(stateIdentifier: initalState.stateIdentifier)
    }
    
    init(state: MovieDetailState) {
        self.actionCreator = ActionCreatorAssembler().resolve(movieId: state.movieId)
        self.initalState = state
    }
    
    @State var imageOverlayOpacity: CGFloat = 0
    @State var imageOffset: CGFloat = 0
    @State var navigationBarOpacity: CGFloat = 0
    
    private func mapAction(action: Action) -> MapAction {
        MapAction(id: initalState.stateIdentifier, originalAction: action)
    }
    
    var body: some View {
        
        let _ = RefreshChecker()
        GeometryReader { geometory in
            ZStack(alignment: .top) {
                switch state.movie {
                case .data(let movieDetail):
                    content(movieDetail: movieDetail, safeAreaInsetsTop: geometory.safeAreaInsets.top)
                case .loading:
                    content(movieDetail: MovieDetail.demos(), safeAreaInsetsTop: geometory.safeAreaInsets.top, isLoading: true)
                case .error(_):
                    CenterProgressView()
                }
                navigationBar(height: geometory.safeAreaInsets.top)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color.Background.main)
            .onDidLoad {
                Task {
                    await store.dispatch(RoutingStateAction.setInitialState(state: initalState))
                    await store.dispatch(mapAction(action: actionCreator.getMovieDetail()))
                    await store.dispatch(mapAction(action: actionCreator.getImages()))
                    await store.dispatch(mapAction(action: actionCreator.getCreditList()))
                    await store.dispatch(mapAction(action: actionCreator.getReviews()))
//                    await store.dispatch(actionCreator.isFavorite(movieId: movieId))
                }
            }
        }
    }
    
    func content(movieDetail: MovieDetail, safeAreaInsetsTop: CGFloat, isLoading: Bool = false) -> some View {
        OffsetReadableScrollView(onChangeOffset: { offset in
            self.imageOverlayOpacity = -offset.y / NetworkImageView.height()
            self.imageOffset = min(-offset.y / 3.0, -offset.y)
            self.navigationBarOpacity = min(CGFloat(-offset.y / (NetworkImageView.height() - safeAreaInsetsTop)), 1.0)
        }) {
            heaerImage(movieDetail: movieDetail, isLoading: isLoading)
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.Background.main.opacity(0.1) : Color.Background.main,
                    Color.Background.main
                ]), startPoint: .top, endPoint: .bottom)
                detail(movieDetail: movieDetail, isLoading: isLoading)
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
    
    func detail(movieDetail: MovieDetail, isLoading: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack(alignment: .center, spacing: 16) {
                FavoriteButton(isFavorite: state.isFavorite) { isFavorite in
                    Task {
                        if isFavorite {
                            await store.dispatch(actionCreator.removeFavorite(movie: movieDetail))
                        } else {
                            await store.dispatch(actionCreator.addFavorite(movie: movieDetail))
                        }
                    }
                }
                VStack(alignment: .center ,spacing: 0.0) {
                    Text("\(movieDetail.reviewersCount)")
                        .font(.titleS())
                    Text("Reviewers")
                        .font(.captionM())
                }
                ScoreView(score: movieDetail.rate)
                    .frame(width: 60, height: 60)
            }
            Spacer().frame(height: 20)
            Text(movieDetail.title)
                .font(.titleM())
            + Text(" (\(movieDetail.year))")
                .font(.titleS())
            Text(movieDetail.screeningTime)
            Spacer().frame(height: 20)
            if !movieDetail.overview.isEmpty {
                Text("Stories")
                    .font(.subTitleL())
                Spacer().frame(height: 20)
                Text(movieDetail.overview)
                    .font(.bodyM())
                Spacer().frame(height: 20)
            }
            BackdropView(backdrops: state.backdrops)
            Spacer().frame(height: 20)
            CastListView(creditList: state.creditList) { personId in
//                Task {
//                    await store.dispatch(RoutingStateAction.Tab.show(.filmography(personId: personId, type: .cast)))
//                }
            }
            Spacer().frame(height: 20)
            AboutFilmView(movieDetail: movieDetail, creditList: state.creditList)
            Spacer().frame(height: 20)
            CreatorListView(creditList: state.creditList) { personId in
//                Task {
//                    await store.dispatch(RoutingStateAction.Tab.show(.filmography(personId: personId, type: .crew)))
//                }
            }
            Spacer().frame(height: 20)
            ReviewView(reviews: state.reviews)
        }
        .padding()
    }
    
    func navigationBar(height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial.opacity(navigationBarOpacity))
                .frame(height: height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MovieDetailContentView(state: MovieDetailState())
        .environmentObject(store)
}
