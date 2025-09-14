//
//  OffsetReadableScrollView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/26.
//

import SwiftUI

struct OffsetReadableScrollViewPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

struct OffsetReadableScrollView<Content: View>: View {
    let onChangeOffset: (CGPoint) -> Void
    let content: () -> Content
    
    public init(
        onChangeOffset: @escaping (CGPoint) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onChangeOffset = onChangeOffset
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                content()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(
                                    key: OffsetReadableScrollViewPreferenceKey.self,
                                    value: geometry.frame(in: .named("scroll")).origin
                                )
                        }
                    )
            }
        }
        .onPreferenceChange(OffsetReadableScrollViewPreferenceKey.self) { offset in
            Task { @MainActor in
                onChangeOffset(offset)
            }
        }
    }
}

//#Preview {
//    OffsetReadableScrollView()
//}
