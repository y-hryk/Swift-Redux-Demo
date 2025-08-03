//
//  MaintenanceScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import SwiftUI

struct MaintenanceScreen: View {
    @StateObject var store: Redux.LocalStore<MaintenancePageState>
    let maintenanceActionCreator: MaintenancePageActionCreator<MaintenancePageState>
    var body: some View {
        VStack {
            Text("Under maintenance")
                .font(.titleLargeS())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 10)
            
            Text("Click the button below to check the latest maintenance status.")
                .font(.bodyM())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 50)
            
            PrimaryButton(title: "Update") {
                Task {
                    await store.dispatch(maintenanceActionCreator.signIn())
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
    }
}

#Preview {
    let store = Redux.LocalStore<MaintenancePageState>(
        initialState: MaintenancePageState(),
        reducer: { state, action in state },
        middleware: [],
        afterMiddleware: nil
    )
    MaintenanceScreen(store: store, maintenanceActionCreator: ActionCreatorAssembler().resolve())
}
