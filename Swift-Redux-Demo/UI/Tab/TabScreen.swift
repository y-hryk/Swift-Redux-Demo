//
//  TabPage.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/19.
//

import SwiftUI

struct TabScreen: View {
    @StateObject var store: Redux.LocalStore<TabState>
    @StateBinding(\.routingState.selecedTab, default: .movie) var selecedTab
    
    var body: some View {
        SignedInTabView(selecedTab: selecedTab) { tab in
            Task {
                await store.dispatch(RoutingStateAction.tabSelected(tab: tab))
            }
        }
    }
}

struct LazyView: View {
    var path: RoutingPath
    
    init(_ path: RoutingPath) {
        self.path = path
    }
    
    var body: some View {
        path.destination()
    }
}


struct SignedInTabView: View, Equatable {
    let selecedTab: Tab
    let selectedHandler: (Tab) -> Void
    
    var body: some View {
        TabView(selection: Binding(
            get: { selecedTab },
            set: { value, _ in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                if selecedTab != value {
                    selectedHandler(value)
                }
            }
        )) {
            LazyView(RoutingPath.movieList)
                .tabItem {
                    Label("Movie", systemImage: "movieclapper")
                }
                .tag(Tab.movie)
            LazyView(RoutingPath.watchList)
                .tabItem {
                    Label("Watch List", systemImage: "star")
                }
                .tag(Tab.watchList)
            LazyView(RoutingPath.debug)
                .tabItem {
                    Label("Debug", systemImage: "wrench.and.screwdriver")
                }
                .tag(Tab.debug)
        }
        .tint(Color(red: 138 / 255, green: 111 / 255, blue: 245 / 255, opacity:1.0))
    }
    
    // Equatableの実装: selectedTabのみを比較
    nonisolated static func == (lhs: SignedInTabView, rhs: SignedInTabView) -> Bool {
        return lhs.selecedTab == rhs.selecedTab
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: TabState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    TabScreen(store: store)
        .environment(\.globalStore, globalStore)
}
