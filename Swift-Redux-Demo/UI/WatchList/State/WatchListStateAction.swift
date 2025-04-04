import Foundation

enum WatchListStateAction: Action {
    case didReceiveFavorites(AsyncValue<[MovieDetail]>)
}

struct WatchListStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let favoriteRepository: FavoriteRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func getFavorites() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let favorites = try await dependency.favoriteRepository.getFavorites()
                return WatchListStateAction.didReceiveFavorites(.data(value: favorites))
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
