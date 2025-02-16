//
//  PrimaryButton.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/28.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let handler: (() -> Void)
    
    var body: some View {
        Button(action: {
            handler()
        }) {
            Text(title)
                .foregroundStyle(.white)
                .font(.buttonM())
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 176 / 255, green: 101 / 255, blue: 224 / 255, opacity:1.0),
                            Color(red: 138 / 255, green: 111 / 255, blue: 245 / 255, opacity:1.0)
                        ]),
                            startPoint: .leading,
                            endPoint: .trailing)
                )
        }
        .accentColor(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    PrimaryButton(title: "primary button") {
        
    }
}
