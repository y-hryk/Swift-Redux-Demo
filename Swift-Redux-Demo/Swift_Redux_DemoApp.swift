//
//  Swift_Redux_DemoApp.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

let globalStore = Redux.GlobalStore(
    reducer: GlobalState.reducer,
    afterMiddleware: Redux.traceAfterMiddleware()
)

@main
struct Swift_Redux_DemoApp: App {
    @StateObject private var stateObservationBuilder: StateObservationBuilder

    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = Color.Background.main.toUIColor()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        _stateObservationBuilder = StateObject(wrappedValue: StateObservationBuilder(store: globalStore))
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootScreen(
                store: LocalStoreBuilder.create(initialState: AppRootState(), reducer: AppRootState.reducer),
                authenticationStateActionCreator: ActionCreatorAssembler().resolve(),
                deepLinkStateActionCreator: ActionCreatorAssembler().resolve()
            )
            .environmentObject(globalStore)
            .environment(\.globalStore, globalStore)
            .environmentObject(stateObservationBuilder)
        }
    }
}
