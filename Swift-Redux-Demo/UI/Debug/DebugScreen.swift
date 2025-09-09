//
//  DebugScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import SwiftUI

struct DebugScreen: View {
    @StateObject var store: Redux.LocalStore<DebugPageState>
    let actionCreator = DebugPageStateActionCreator(with: DebugPageStateActionCreator.Dependency())
    
    var body: some View {
        NavigationStack() {
            VStack {
                Text("increment Count \(store.state.count)")
                    .animation(.easeInOut, value: store.state.count)
                List {
                    ListTextButton("Reboot") {
                        Task {
                            await store.dispatch(ApplicationAction.startScreenChanged(startScreen: .splash))
                        }
                    }
                    ListTextButton("Add async processing") {
                        for _ in 0..<1000 {
                          Task.detached {
                              await store.dispatch(DebugPageStateAction.increment)
                          }
                        }
                    }
                    ListTextButton("503 Maintenance") {
                        Task {
                            await store.dispatch(ApplicationAction.errorReceived(NetworkError.serviceUnavailable))
                        }
                    }
                    ListTextButton("401 Unauthorized") {
                        Task {
                            await store.dispatch(ApplicationAction.errorReceived(NetworkError.unauthorized))
                        }
                    }
                    ListTextButton("Show Toast") {
                        Task {
                            await store.dispatch(ToastStateAction.didReceiveToast(
                                Toast(style: .success, title: "Show Toast", message: "xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx ")
                            ))
                        }
                    }
                    ListTextButton("Show Modal") {
                        Task {
                            await store.dispatch(RoutingStateAction.modalShown(ModalItem(routingPath: RoutingPath.debugFirstModel, presentationStyle: .fullScreenCover)))
                        }
                    }
                    ListTextButton("Show FullScreen Indicator") {
                        Task {
                            await store.dispatch(ApplicationAction.indicatorShown(true))
                            try? await Task.sleep(for: .seconds(3))
                            await store.dispatch(ApplicationAction.indicatorShown(false))
                        }
                    }
                    ListTextButton("DeepLink MovieDetail") {
                        Task {
                            await store.dispatch(DeepLinkAction.deepLinkReceived(DeepLink(to: .movieDetail(MovieId(value: "550")))))
                        }
                    }
                    ListTextButton("DeepLink WatchList") {
                        Task {
                            await store.dispatch(DeepLinkAction.deepLinkReceived(DeepLink(to: .watchList)))
                        }
                    }
                    ListTextButton("DeepLink FirstModal") {
                        Task {
                            await store.dispatch(DeepLinkAction.deepLinkReceived(DeepLink(to: .firstModal)))
                        }
                    }

                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color.Background.main)
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.Background.main)
        }
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: DebugPageState.preview())
        .build()
    
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer,
        afterMiddleware: Redux.traceAfterMiddleware()
    )
    DebugScreen(store: store)
        .environment(\.globalStore, globalStore)
}
