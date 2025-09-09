//
//  Swift_Redux_DemoApp.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

let globalStore = Redux.GlobalStore(
    reducer: ApplicationState.reducer,
    isTraceEnabled: true
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
            AppRootScreen(
                store: LocalStoreBuilder.default(initialState: AppRootState()).build(),
                deepLinkStateActionCreator: ActionCreatorAssembler().resolve(),
                authenticationStateActionCreator: ActionCreatorAssembler().resolve()
            )
            .environment(\.globalStore, globalStore)
        }
    }
}
