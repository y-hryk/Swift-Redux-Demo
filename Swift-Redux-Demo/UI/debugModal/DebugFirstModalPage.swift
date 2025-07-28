//
//  DebugFirstModal.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/23.
//

import SwiftUI

struct DebugFirstModalPage: View {
    @StateObject var store: Redux.LocalStore<EmptyState>
    
    var body: some View {
        NavigationStack() {
            VStack {
                List {
                    ListTextButton("Reboot") {
                        Task {
                            await store.dispatch(GlobalStateAction.update(startScreen: .splash))
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
                            await store.dispatch(GlobalStateAction.didReceiveError(NetworkError.unauthorized))
                        }
                    }
                    ListTextButton("Show Modal") {
                        Task {
                            await store.dispatch(RoutingStateAction.showModal(ModalItem(routingPath: RoutingPath.debugSecondModal, presentationStyle: .sheet)))
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
