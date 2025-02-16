//
//  ListTextButton.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/11.
//

import SwiftUI

struct ListTextButton: View {
    var title: String
    var completion: () -> Void
    
    init(_ title: String, completion: @escaping () -> Void) {
        self.title = title
        self.completion = completion
    }
    
    var body: some View {
        Button {
            completion()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        // ButtonStyleでタップ中のスタイルを指定
        .buttonStyle(ListButtonStyle())
        .listRowInsets(.init())
    }
}
