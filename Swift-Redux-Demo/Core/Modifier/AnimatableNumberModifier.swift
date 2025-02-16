//
//  AnimatableNumberModifier.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/26.
//

import SwiftUI

struct AnimatableNumberModifier: AnimatableModifier {
    var number: Double
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(Int(number))")
            )
    }
}

extension View {
    func animatingOverlay(for number: Double) -> some View {
        modifier(AnimatableNumberModifier(number: number))
    }
}
