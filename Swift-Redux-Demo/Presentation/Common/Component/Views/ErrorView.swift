//
//  ErrorView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/10/01.
//

import SwiftUI

struct ErrorView: View {
    var onPressed: (() -> Void)? = nil
    var body: some View {
        VStack {
            Text("Connection Error")
                .font(.bodyNumber50())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 10)
            
            Text("Please check your network environment and try again.")
                .font(.body50())
                .padding(.horizontal, 16)
            
            Spacer().frame(height: 50)
            
            PrimaryButton(title: "Retry") {
                onPressed?()
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background.main)
    }
}

#Preview {
    ErrorView()
}
