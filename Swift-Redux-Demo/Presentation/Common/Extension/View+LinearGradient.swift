//
//  View+LinearGradient.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/01.
//

import SwiftUI

extension View {
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
}
