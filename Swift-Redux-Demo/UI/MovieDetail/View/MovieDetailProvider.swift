//
//  MovieDetailProvider.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/21.
//

import SwiftUI

struct MovieDetailProvider: View {
    @EnvironmentObject var store: ReduxStore<AppState>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MovieDetailProvider()
        .environmentObject(store)
}
