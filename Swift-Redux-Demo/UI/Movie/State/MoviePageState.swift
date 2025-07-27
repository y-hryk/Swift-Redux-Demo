//
//  MovieListState.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/07.
//

import UIKit

struct MoviePageState: Redux.State {
    var movieList: AsyncValue<MovieList>
    var presentedUserSetting: Bool
}

extension MoviePageState {
    init() {
        movieList = .loading
        presentedUserSetting = false
    }
}
