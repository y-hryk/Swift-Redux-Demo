//
//  FavoriteStateAction.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/07/20.
//

enum FavoriteStateAction: Redux.GlobalAction {
    case addFavorite(detail: MovieDetail)
    case removeFavorite(detail: MovieDetail)
}
