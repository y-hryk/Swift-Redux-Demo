//
//  MaintenanceContentView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import SwiftUI

struct MaintenancePage: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    let actionCreator: MaintenancePageStateActionCreator = ActionCreatorAssembler().resolve()
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
                    await store.dispatch(actionCreator.signIn())
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
    }
}

#Preview {
    MaintenancePage()
}
