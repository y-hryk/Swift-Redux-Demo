import UIKit

struct WatchListPageState: ApplicationState {
    var movies: AsyncValue<[MovieDetail]>
}

extension WatchListPageState {
    init() {
        self.movies = .loading
    }
}
