//
//  ReduxMapStore.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/09.
//

struct StateMapReduxStore<State: ApplicationState> {
    let id: any ID
    let store: ReduxStore<State>
    
    func dispatch(_ action: Action, file: String = #fileID, line: Int = #line, function: String = #function) async {
        await store.dispatch(
            MapAction(id: id, originalAction: action),
            caller: "\(file):\(line) >>> \(function)"
        )
    }
}
