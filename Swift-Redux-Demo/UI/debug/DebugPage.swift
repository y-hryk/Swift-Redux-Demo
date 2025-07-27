//
//  SettingsPage.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import SwiftUI

struct DebugPage: View {
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
                            await store.dispatch(GlobalStateAction.update(startScreen: .splash))
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
                            await store.dispatch(GlobalStateAction.didReceiveError(NetworkError.serviceUnavailable))
                        }
                    }
                    ListTextButton("401 Unauthorized") {
                        Task {
                            await store.dispatch(GlobalStateAction.didReceiveError(NetworkError.unauthorized))
                        }
                    }
                    ListTextButton("Show Toast") {
                        Task {
                            await store.dispatch(ToastStateAction.didReceiveToast(
                                Toast(style: .success, title: "", message: "Show Toast")
                            ))
                        }
                    }
                    ListTextButton("Show Modal") {
                        Task {
                            await store.dispatch(RoutingStateAction.showModal(ModalItem(routingPath: RoutingPath.debugFirstModel, presentationStyle: .sheet)))
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
//    DebugPage()
//        .environmentObject(store)
}
