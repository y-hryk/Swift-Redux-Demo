//
//  Untitled.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/02/01.
//

import SwiftUI

struct NavigationModifier: ViewModifier {
    @Binding var paths: [NavigationStackPath]

    func body(content: Content) -> some View {
        NavigationStack(path: $paths) {
            content
                .navigationDestination(for: NavigationStackPath.self) { route in
                    route.destination()
                }
                .background(Color.Background.main)
        }
    }
}

extension View {
    func navigation(path: Binding<[NavigationStackPath]>) -> some View {
        self.modifier(NavigationModifier(paths: path))
    }
}
