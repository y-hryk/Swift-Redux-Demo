import UIKit

struct WatchListPageState: Redux.State {
}

extension WatchListPageState {
    static func preview() -> WatchListPageState {
        .init()
    }
}

extension WatchListPageState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        return state
    }
}
