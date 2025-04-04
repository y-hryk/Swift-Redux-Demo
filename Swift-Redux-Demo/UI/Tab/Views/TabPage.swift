//
//  TabPage.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/19.
//

import SwiftUI

struct TabContentView: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    var state: TabState { store.state.routingState.tabState }
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = Color.Background.main.toUIColor()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: Binding(
            get: { state.seleced },
            set: { value, _ in
                if state.seleced == value {
                    Task {
//                        await store.dispatch(RoutingStateAction.updateMovieList([]))
                    }
                } else {
                    Task {
                        await store.dispatch(TabStateAction.select(tab: value))
                    }
                }
            }
        )) {
            MovieListContentView()
                .tabItem {
                    Label("Movie", systemImage: "movieclapper")
                }
                .tag(Tab.movie)
            WatchListContentView()
                .tabItem {
                    Label("Watch List", systemImage: "star")
                }
                .tag(Tab.watchList)
            DebugPage()
                .tabItem {
                    Label("Debug", systemImage: "wrench.and.screwdriver")
                }
                .tag(Tab.debug)
        }
        .tint(Color(red: 138 / 255, green: 111 / 255, blue: 245 / 255, opacity:1.0))
    }
}

#Preview {
    TabContentView()
        .environmentObject(store)
}
