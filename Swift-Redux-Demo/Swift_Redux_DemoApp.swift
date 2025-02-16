//
//  Swift_Redux_DemoApp.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

let store = ReduxStore(
    reducer: AppState.reducer,
    middlewares: [
        debugDelayRequestMiddleware(),
        thunkMiddleware(),
        errorToastMiddleware(),
        webApiErrorHandleMiddleware()
//        Middlewares.errorToast,
//        Middlewares.webApiErrorHandle
    ],
    afterMiddlerare: Middlewares.loggerAfter
)

@main
struct Swift_Redux_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ApplicationRootView()
                .environmentObject(store)
                .environmentObject(AppEnvironment())
        }
    }
}

struct ApplicationRootView: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    let actionCreator: AuthenticationStateActionCreator = ActionCreatorAssembler().resolve()
    var state: AppState { store.state }
    
    var body: some View {
        VStack {
            switch store.state.globalState.startScreen {
            case .splash:
                SplashContentView()
            case .root:
                TabContentView()
            case .onboarding:
                SignInContentView()
            case .maintenance:
                MaintenancePage()
            }
        }
        .animation(.easeInOut, value: store.state.globalState.startScreen)
        .onChange(of: state.globalState.authenticationState.shouldLogoutTriger) { oldValue, newValue in
            if newValue {
                Task {
                    await store.dispatch(actionCreator.signOut())
                }
            }
        }
        .toastView(toast: Binding(
            get: { state.toastState.toast },
            set: { value, _ in
                Task {
                    print("++ show Toast")
                    await store.dispatch(ToastStateAction.didReceiveToast(value))
                }
            })
        )
        .onAppear() {
            Task {
//                await store.dispatch(actionCreator.isSignIn())
            }
        }

    }
}

#Preview {
    ApplicationRootView()
        .environmentObject(store)
}
