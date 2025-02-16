//
//  ViewHiddenModifier.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/03.
//

import SwiftUI

struct ViewHiddenModifier : ViewModifier {
    let hidden: Bool
    @ViewBuilder
    func body(content: Content) -> some View {
        ZStack {
            if hidden {
                EmptyView()
            } else {
                content
            }
        }
        .animation(.easeInOut, value: hidden)
    }
}

extension View {
    func hidden(_ hidden: Bool) -> some View {
        modifier(ViewHiddenModifier(hidden: hidden))
    }
}
