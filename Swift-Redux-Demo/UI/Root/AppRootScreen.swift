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
    let deepLinkStateActionCreator: DeepLinkStateActionCreator<AppRootState>
    let authenticationStateActionCreator: AuthenticationStateActionCreator<AppRootState>
    @StateBinding(\.startScreen, default: StartScreen.splash) var startScreen
    @StateBinding(\.deepLinkState.deepLink, default: nil) var deepLink
    @StateBinding(\.authenticationState.shouldLogoutTriger, default: false) var shouldLogoutTriger
    @StateBinding(\.toastState.toast, default: nil) var toast
    @StateBinding(\.routingState.modalPaths, default: []) var modalPaths
    @StateBinding(\.showIndicator, default: false) var showIndicator
    
    
    var body: some View {
        ZStack {
            VStack {
                StartScreenView(startScreen: startScreen)
            }
            .animation(.easeInOut, value: startScreen)
        }
        .onOpenURL { url in
            let deepLink = DeepLink.handleDeepLink(url: url, isSignIn: globalStore.state.authenticationState.isAuthenticated)
            Task {
                await store.dispatch(DeepLinkAction.deepLinkReceived(deepLink))
            }
        }
        .onChange(of: deepLink) { _, newValue in
            Task {
                await store.dispatch(deepLinkStateActionCreator.startDeepLink(deepLink: newValue))
            }
        }
        .onChange(of: shouldLogoutTriger) { oldValue, newValue in
            if newValue {
                Task {
                    await store.dispatch(authenticationStateActionCreator.signOut())
                }
            }
        }
        .toastView(toast: Binding(
            get: { toast },
            set: { value, _ in
                Task {
                    await store.dispatch(ToastStateAction.didReceiveToast(value))
                }
            })
        )
        .modalStack(path: Binding(
            get: {
                modalPaths
            },
            set: { value in
                Task {
                    await store.dispatch(RoutingStateAction.modalNavigationsChanged(value))
                }
            }
        ))
        .loadingOverlay(isLoading: Binding(
            get: {
                showIndicator
            },
            set: { value in
                Task {
                    await store.dispatch(GlobalStateAction.indicatorShown(value))
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
