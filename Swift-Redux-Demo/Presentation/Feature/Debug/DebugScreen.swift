//
//  DebugScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import SwiftUI

struct DebugScreen: View {
    @StateObject var store: Redux.LocalStore<DebugState>
    let actionCreator: DebugStateActionCreator<DebugState>
    
    init(state: DebugState,
         actionCreator: DebugStateActionCreator<DebugState>,
         type: Redux.LocalStoreType = .normal) {
        _store = StateObject(wrappedValue: LocalStoreBuilder
            .create(initialState: state, type: type)
            .build()
        )
        self.actionCreator = actionCreator
    }
    
    var body: some View {
        NavigationStack() {
            VStack {
                Text("increment Count \(store.state.count)")
                    .font(.body50())
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
                              await store.dispatch(DebugStateAction.increment)
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
                    ListTextButton("400 Error") {
                        Task {
                            await store.dispatch(
                                ApplicationAction.errorReceived(NetworkError.badRequest(
                                    code: 400,
                                    message: "sample error")
                                )
                            )
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
                    ListTextButton("DeepLink Modal") {
                        Task {
                            await store.dispatch(DeepLinkAction.deepLinkReceived(DeepLink(to: .modal)))
                        }
                    }
                    
                    ListTextButton("DeepLink Modal(Nested)") {
                        Task {
                            await store.dispatch(DeepLinkAction.deepLinkReceived(DeepLink(to: .modalNested)))
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
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    DebugScreen(state: DebugState.preview(),
                actionCreator: DebugStateActionCreator(),
                type: .stub)
        .environment(\.globalStore, globalStore)
}
