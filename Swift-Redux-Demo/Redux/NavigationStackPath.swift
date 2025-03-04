import SwiftUI

enum NavigationStackPath: Hashable {
    case movieDetail(movieId: MovieId)
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .movieDetail:
            MovieDetailContentView(state: initilState() as! MovieDetailState)
        }
    }
    
    func initilState() -> any ApplicationState {
        switch self {
        case .movieDetail(let movieId):
            return MovieDetailState.fromId(movieId: movieId)
        }
    }
}
