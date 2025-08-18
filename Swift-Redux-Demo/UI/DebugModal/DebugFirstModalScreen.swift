//
//  DebugFirstModalScreen.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/23.
//

import SwiftUI

struct DebugFirstModalScreen: View {
    @StateObject var store: Redux.LocalStore<EmptyState>
    
    var body: some View {
        let _ = print("DebugFirstModalScreen body")
        NavigationStack() {
            VStack {
                List {
                    ListTextButton("Reboot") {
                        Task {
                            await store.dispatch(GlobalStateAction.startScreenChanged(startScreen: .splash))
                        }
                    }
                    ListTextButton("Show Toast") {
                        Task {
                            await store.dispatch(ToastStateAction.didReceiveToast(
                                Toast(style: .success, title: "", message: "Show Toast")
                            ))
                        }
                    }
                    ListTextButton("401 Unauthorized") {
                        Task {
                            await store.dispatch(GlobalStateAction.errorReceived(NetworkError.unauthorized))
                        }
                    }
                    ListTextButton("Show Modal") {
                        Task {
                            await store.dispatch(RoutingStateAction.modalShown(ModalItem(routingPath: RoutingPath.debugSecondModal, presentationStyle: .sheet)))
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        Task {
                            await store.dispatch(RoutingStateAction.modalDismissed)
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(Color.tint)
                        
                    })
                }
            }
        }
    }
}
