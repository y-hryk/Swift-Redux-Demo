import UIKit

struct WatchListState: Redux.State {
}

extension WatchListState {
    static func preview() -> WatchListState {
        .init()
    }
}

extension WatchListState {
    static let reducer: Redux.Reducer<Self> = { state, action in
        var state = state
        return state
    }
}
