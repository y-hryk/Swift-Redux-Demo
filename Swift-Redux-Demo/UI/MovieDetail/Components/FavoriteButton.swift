//
//  FavoriteButton.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/09.
//

import SwiftUI

struct FavoriteButton: View, Equatable {
    static func == (lhs: FavoriteButton, rhs: FavoriteButton) -> Bool {
        return lhs.isFavorite.value == rhs.isFavorite.value
    }
    
    let isFavorite: AsyncValue<Bool>
    let completionHandler: ((Bool) -> Void)
    
    init(isFavorite: AsyncValue<Bool>, completionHandler: @escaping (Bool) -> Void) {
        self.isFavorite = isFavorite
        self.completionHandler = completionHandler
    }
    
    var body: some View {
        let _ = print(">> FavoriteButton body")
        switch isFavorite {
        case .data(let isFavorite):
            PrimaryButton(title: isFavorite ? "Remove Watch List" : "Add Watch List") {
                completionHandler(isFavorite)
            }
        case .loading:
            ZStack {
                PrimaryButton(title: "") {}
                ProgressView()
                    .tint(.white)
            }
        case .error:
            ZStack {
                PrimaryButton(title: "") {}
                ProgressView()
                    .tint(.white)
            }
        }
    }
}

#Preview {
    FavoriteButton(isFavorite: .loading) { _ in
        
    }
}
