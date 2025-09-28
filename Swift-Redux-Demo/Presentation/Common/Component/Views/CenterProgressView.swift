//
//  CenterProgressView.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/04.
//

import SwiftUI

struct CenterProgressView: View {
    let title: String?
    init(title: String? = nil) {
        self.title = title
    }
    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {
            ProgressView()
            if let title = title {
                Text(title)
                    .font(.bodyB50())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CenterProgressView()
}
