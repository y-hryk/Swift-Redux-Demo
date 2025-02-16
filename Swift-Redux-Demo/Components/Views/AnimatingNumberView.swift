//
//  AnimatingNumberView.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/01/26.
//

import SwiftUI

struct AnimatingNumberView: View {
    @State private var number: Double = 0
    
    init(number: Double) {
        self.number = number
    }

    var body: some View {
        VStack(spacing: 20) {
            Color.clear
                .frame(width: 50, height: 50)
                .animatingOverlay(for: number)
        }
    }
}

