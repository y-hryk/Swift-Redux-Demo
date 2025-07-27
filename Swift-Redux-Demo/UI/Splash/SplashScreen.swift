//
//  SplashPage.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/01.
//

import SwiftUI

struct SplashScreen: View {
    @StateObject var store: Redux.LocalStore<SplashPageState>
    let actionCreator: AuthenticationStateActionCreator<SplashPageState>

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
//    SplashContentView()
//        .environmentObject(store)
}
