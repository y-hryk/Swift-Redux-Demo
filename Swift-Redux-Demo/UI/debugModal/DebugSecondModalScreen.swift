//
//  DebugSecondModalScreen.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/23.
//

import SwiftUI

struct DebugSecondModalScreen: View {
    @StateObject var store: Redux.LocalStore<EmptyState>
    
    var body: some View {
        Text("DebugSecondModalPage")
    }
}
