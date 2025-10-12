//
//  Swift_Redux_DemoApp.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2024/12/31.
//

import SwiftUI

@main
struct Swift_Redux_DemoApp: App {
    @StateObject private var stateObservationBuilder: StateObservationBuilder
    
    init() {
        let _ = AppConfiguration.shared
        _stateObservationBuilder = StateObject(wrappedValue: StateObservationBuilder(store: globalStore))
        setupAppearance()
    }
    
    private func setupAppearance() {
        let tabAppearance: UITabBarAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = Color.Background.main.toUIColor()
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().standardAppearance = tabAppearance
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = UIColor(Color.Background.main)
        navigationAppearance.shadowColor = .clear
        
        navigationAppearance.titleTextAttributes = [
            .font: UIFont(name: "Futura", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold),
        ]
        navigationAppearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .heavy),
        ]
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            if AppConfiguration.shared.isLoaded {
                AppRootScreen(
                    state: AppRootState(),
                    deepLinkStateActionCreator: DeepLinkStateActionCreator(),
                    authenticationStateActionCreator: AuthenticationStateActionCreator()
                )
                .environment(\.globalStore, globalStore)
                .environmentObject(stateObservationBuilder)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 Please copy it to Config.plist and update with your values.")
                    Text("⚠️ No configuration loaded. Please create Config.plist file.")
                    Text("📌 Don't forget to add Config.plist to target membership!")
                }
            }
        }
    }
}
