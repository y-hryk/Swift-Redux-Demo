//
//  Swift_Redux_DemoApp.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

//let store = ReduxStore(
//    initialState: AppState(),
//    reducer: AppState.reducer,
//    middleware: [
////        debugDelayRequestMiddleware(),
////        thunkMiddleware(),
////        errorToastMiddleware(),
////        webApiErrorHandleMiddleware()
////        Middlewares.errorToast,
////        Middlewares.webApiErrorHandle
//    ],
//    afterMiddleware: Middlewares.loggerAfter
//)

let globalStore = Redux.GlobalStore(
    reducer: GlobalState.reducer,
    afterMiddleware: Redux.traceAfterMiddleware()
)

@main
struct Swift_Redux_DemoApp: App {
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = Color.Background.main.toUIColor()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootContentView(
                store: LocalStoreBuilder.create(initialState: AppRootState(), reducer: AppRootState.reducer),
                actionCreator: ActionCreatorAssembler().resolve()
            )
            .environmentObject(globalStore)
        }
    }
}
