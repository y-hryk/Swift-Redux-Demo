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

extension NavigationStackPath: Equatable {
    static func == (lhs: NavigationStackPath, rhs: NavigationStackPath) -> Bool {
        lhs.initilState().stateIdentifier == rhs.initilState().stateIdentifier
    }
}
