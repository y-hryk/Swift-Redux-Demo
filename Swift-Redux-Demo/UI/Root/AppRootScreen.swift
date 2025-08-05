//
//  AppRootScreen.swift
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

struct AppRootScreen: View {
    @EnvironmentObject var globalStore: Redux.GlobalStore
    @StateObject var store: Redux.LocalStore<AppRootState>
    let authenticationStateActionCreator: AuthenticationStateActionCreator<AppRootState>
    let deepLinkStateActionCreator: DeepLinkStateActionCreator<AppRootState>
    
    var body: some View {
        ZStack {
            VStack {
                StartScreenView(startScreen: globalStore.state.startScreen)
            }
            .animation(.easeInOut, value: globalStore.state.startScreen)
        }
        .onOpenURL { url in
            print(url)
            let deepLink = DeepLink.handleDeepLink(url: url, isSignIn: globalStore.state.authenticationState.isAuthenticated)
            Task {
                await store.dispatch(DeepLinkAction.updateDeepLink(deepLink))
            }
        }
        .onAppear() {
            Task {
                await store.dispatch(authenticationStateActionCreator.isSignIn())
            }
        }
        .onChange(of: globalStore.state.authenticationState.shouldLogoutTriger) { oldValue, newValue in
            if newValue {
                Task {
                    await store.dispatch(authenticationStateActionCreator.signOut())
                }
            }
        }
        .onChange(of: globalStore.state.authenticationState.shouldLogoutTriger) { _, newValue in
            if newValue {
                Task {
                    await store.dispatch(authenticationStateActionCreator.signOut())
                }
            }
        }
        .onChange(of: globalStore.state.deepLinkState.deepLink) { _, newValue in
            Task {
                await store.dispatch(deepLinkStateActionCreator.execute(deepLink: newValue))
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
        .modalStack(path: Binding(
            get: {
                globalStore.state.routingState.modalPaths
            },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.updateModel(value))
                }
            }
        ))
        .loadingOverlay(isLoading: Binding(
            get: {
                globalStore.state.showIndicator
            },
            set: { value in
                Task {
                    await store.dispatch(GlobalStateAction.showIndicator(value))
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
