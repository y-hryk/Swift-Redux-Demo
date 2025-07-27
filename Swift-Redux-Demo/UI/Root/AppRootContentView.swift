//
//  AppRootContentView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/16.
//

import SwiftUI

struct StartScreenView: View {
    let startScreen: StartScreen
    
    var body: some View {
        switch startScreen {
        case .signedIn:
            RoutingPath.signedIn.destination()
        case .maintenance:
            RoutingPath.maintenance.destination()
        case .splash:
            RoutingPath.splash.destination()
        case .signedOut:
            RoutingPath.signedOut.destination()
        }
    }
}

struct AppRootContentView: View {
    @EnvironmentObject var globalStore: Redux.GlobalStore
    @StateObject var store: Redux.LocalStore<AppRootState>
    let actionCreator: AuthenticationStateActionCreator<AppRootState>
    
    var body: some View {
        ZStack {
            VStack {
                StartScreenView(startScreen: globalStore.state.startScreen)
            }
            .animation(.easeInOut, value: globalStore.state.startScreen)
//            if state.globalState.fullScreenIndicatorVisible {
//                FullScreenIndicator()
//            }
        }
        .onChange(of: globalStore.state.authenticationState.shouldLogoutTriger) { oldValue, newValue in
            if newValue {
                Task {
                    await store.dispatch(actionCreator.signOut())
                }
            }
        }
        .onAppear() {
            Task {
                await store.dispatch(actionCreator.isSignIn())
            }
        }
        .toastView(toast: Binding(
            get: { globalStore.state.toastState.toast },
            set: { value, _ in
                Task {
                    print("++ show Toast")
                    await store.dispatch(ToastStateAction.didReceiveToast(value))
                }
            })
        )
        .infiniteModal(path: Binding(
            get: {
                globalStore.state.routingState.modalPaths
            },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.updateModel(value))
                }
            }
        ))
    }
}

#Preview {
//    let store = Redux.LocalStore<AppRootState>(
//        initialState: AppRootState(),
//        reducer: { state, action in state },
//        middleware: [],
//        afterMiddleware: nil
//    )
//    AppRootContentView(store: store)
//        .environmentObject(globalStore)
}

struct FullScreenIndicator: View {
    var body: some View {
        Color.clear
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
            .contentShape(Rectangle())
            .onTapGesture {}
    }
}
