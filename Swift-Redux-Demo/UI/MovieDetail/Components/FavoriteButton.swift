//
//  FavoriteButton.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/10/09.
//

import SwiftUI

struct FavoriteButton: View {
    
    let isFavorite: Bool
    let completionHandler: ((Bool) -> Void)
    
    init(isFavorite: Bool, completionHandler: @escaping (Bool) -> Void) {
        self.isFavorite = isFavorite
        self.completionHandler = completionHandler
    }
    
    var body: some View {
        PrimaryButton(title: isFavorite ? "Remove Watch List" : "Add Watch List") {
            completionHandler(isFavorite)
        }
    }
}

extension FavoriteButton: Equatable {
    nonisolated static func == (lhs: FavoriteButton, rhs: FavoriteButton) -> Bool {
        return lhs.isFavorite == rhs.isFavorite
    }
}

#Preview {
    FavoriteButton(isFavorite: false) { _ in
        
    }
}
