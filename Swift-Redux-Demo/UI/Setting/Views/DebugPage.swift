//
//  SettingsPage.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/10.
//

import SwiftUI

struct DebugPage: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    var state: DebugPageState { store.state.routingState.tabState.settingsPageState }
    let actionCreator = DebugPageStateActionCreator(with: DebugPageStateActionCreator.Dependency())
    
//    var body: some View {
//        NavigationStack {
//            Text("increment Count \(state.count)")
//                .animation(.easeInOut, value: state.count)
////            AnimatingNumberView(number: Double(state.count))
////            Text("increment Count \(state.count) (Middlewares)")
//            List {
//                ListTextButton("Reboot") {
//                    Task {
//                        await store.dispatch(GlobalStateAction.update(startScreen: .splash))
//                    }
//                }
//                ListTextButton("Add async processing") {
//                    for _ in 0..<1000 {
//                      Task.detached {
//                          await store.dispatch(DebugPageStateAction.increment)
//                      }
//                    }
//                }
//                ListTextButton("503 Maintenance") {
//                    Task {
//                        await store.dispatch(GlobalStateAction.didReceiveError(NetworkError.serviceUnavailable))
//                    }
//                }
//                ListTextButton("401 Unauthorized") {
//                    Task {
//                        await store.dispatch(GlobalStateAction.didReceiveError(NetworkError.unauthorized))
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("Debug Menu")
//        }
//        .onDisappear {
//            print(">> DebugContentView onDisappear")
//        }
//    }
    
    var body: some View {
        VStack {
            Text("increment Count \(state.count)")
                .animation(.easeInOut, value: state.count)
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
            }
//            .scrollContentBackground(.hidden)
//            .background(Color.Background.main)
        }
        .navigationTitle("Debug Menu")
        .navigationBarTitleDisplayMode(.inline)
        .navigation(path: Binding(
            get: { [] },
            set: { value in

            }
        ))
        .onDisappear {
            print(">> DebugContentView onDisappear")
        }
    }

}

#Preview {
    DebugPage()
        .environmentObject(store)
}
