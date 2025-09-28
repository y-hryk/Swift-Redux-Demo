//
//  MaintenanceScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import SwiftUI

struct MaintenanceScreen: View {
    @StateObject var store: Redux.LocalStore<MaintenanceState>
    let maintenanceActionCreator: MaintenanceActionCreator<MaintenanceState>
    var body: some View {
        VStack {
            Text("Under maintenance")
                .font(.bodyNumber50())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 10)
            
            Text("Click the button below to check the latest maintenance status.")
                .font(.body50())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 50)
            
            PrimaryButton(title: "Update") {
                Task {
                    await store.dispatch(maintenanceActionCreator.maintenanceCheckRequested())
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
    }
}

#Preview {
    let store = LocalStoreBuilder
        .stub(state: MaintenanceState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    MaintenanceScreen(store: store,
                      maintenanceActionCreator: ActionCreatorAssembler().resolve())
        .environment(\.globalStore, globalStore)
}
