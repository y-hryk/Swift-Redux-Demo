//
//  DebugSecondModalScreen.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/23.
//

import SwiftUI

struct DebugSecondModalScreen: View {
    @StateObject var store: Redux.LocalStore<DebugModalState>
    
    init(state: DebugModalState, type: Redux.LocalStoreType = .normal) {
        _store = StateObject(wrappedValue: LocalStoreBuilder
            .create(initialState: state, type: type)
            .build()
        )
    }
    
    var body: some View {
        Text("DebugSecondModalPage")
    }
}
