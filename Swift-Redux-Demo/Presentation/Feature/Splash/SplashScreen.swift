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
    let store = LocalStoreBuilder
        .stub(state: SplashState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    SplashScreen(store: store,
                 actionCreator: ActionCreatorAssembler().resolve())
        .environment(\.globalStore, globalStore)
}
