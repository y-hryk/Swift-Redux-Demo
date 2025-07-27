//
//  HighlightButtonStyle.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/11.
//

import SwiftUI

struct ListButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color(Color.Background.main)
    var pressedBackgroundColor: Color = Color(Color.gray)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(isPressed: configuration.isPressed))
            .animation(.easeInOut, value: configuration.isPressed)
    }

    func backgroundColor(isPressed: Bool) -> Color {
        return isPressed ? pressedBackgroundColor : backgroundColor
    }
}
