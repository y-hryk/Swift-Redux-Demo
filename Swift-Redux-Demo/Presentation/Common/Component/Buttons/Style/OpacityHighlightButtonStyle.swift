//
//  OpacityHighlightButtonStyle.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/29.
//

import SwiftUI

struct OpacityHighlightButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
