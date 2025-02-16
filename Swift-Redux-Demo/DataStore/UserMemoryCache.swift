//
//  UserMemoryCache.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import Foundation

protocol UserDataStore {
    
}

class UserMemoryCache: UserDataStore {
    static let shared = UserMemoryCache()
    static let defaultValue = User(name: "y-hryk", isEnableNotifications: false, isSignIn: false)
    private init() {}
    var user = defaultValue
    
    func clear() {
        user = UserMemoryCache.defaultValue
    }
}
