//
//  SplashPage.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/01.
//

import SwiftUI

struct SplashScreen: View {
    @StateObject var store: Redux.LocalStore<SplashState>
    let actionCreator: AuthenticationStateActionCreator<SplashState>

    init(state: SplashState,
         actionCreator: AuthenticationStateActionCreator<SplashState>,
         type: Redux.LocalStoreType = .normal
    ) {
        _store = StateObject(wrappedValue: LocalStoreBuilder.create(initialState: state, type: type)
            .build()
        )
        self.actionCreator = actionCreator
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("SplashView")
                .font(.title50())
                .onAppear() {
                    Task {
                        await store.dispatch(actionCreator.verifyAuthentication())
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
    }
}

#Preview {
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    SplashScreen(state: SplashState.preview(),
                 actionCreator: AuthenticationStateActionCreator(),
                 type: .stub)
        .environment(\.globalStore, globalStore)
}
