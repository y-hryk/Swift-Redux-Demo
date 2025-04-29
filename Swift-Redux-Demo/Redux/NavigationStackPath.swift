import SwiftUI

enum NavigationStackPath: Hashable {
    case movieDetail(movieId: MovieId)
    case filmography(personId: PersonId, type: FilmographyType)
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .movieDetail:
            MovieDetailContentView(state: initilState() as! MovieDetailState)
        case .filmography:
            FilmographyContentView(state: initilState() as! FilmographyState)
        }
    }
    
    func initilState() -> any ApplicationState {
        switch self {
        case .movieDetail(let movieId):
            return MovieDetailState.fromId(movieId: movieId)
        case .filmography(let personId, let type):
            return FilmographyState(personId: personId, type: type)
        }
    }
}

extension NavigationStackPath: Equatable {
    static func == (lhs: NavigationStackPath, rhs: NavigationStackPath) -> Bool {
        lhs.initilState().stateIdentifier == rhs.initilState().stateIdentifier
    }
}
