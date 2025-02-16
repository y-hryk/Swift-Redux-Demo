//
//  SplashPage.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/01.
//

import SwiftUI

struct SplashContentView: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    let actionCreator: AuthenticationStateActionCreator = ActionCreatorAssembler().resolve()

    var body: some View {
        VStack(alignment: .center) {
            Text("SplashView")
                .font(.titleM())
                .onAppear() {
                    Task {
                        await store.dispatch(actionCreator.isSignIn())
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
        
    }
}

#Preview {
    SplashContentView()
        .environmentObject(store)
}
