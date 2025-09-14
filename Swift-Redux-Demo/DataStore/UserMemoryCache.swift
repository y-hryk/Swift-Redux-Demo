//
//  UserMemoryCache.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import Foundation

protocol UserDataStore {
    func signIn() async
    func signout() async
    func getUser() async -> User
}

actor UserMemoryCache: UserDataStore {
    static let shared = UserMemoryCache()
    static let defaultValue = User(name: "y-hryk", isEnableNotifications: false, isSignIn: false)
    private init() {}
    var user = defaultValue
    
    func signIn() {
        user =  User(name: "y-hryk", isEnableNotifications: false, isSignIn: true)
    }
    
    func signout() {
        user = UserMemoryCache.defaultValue
    }
    
    func getUser() -> User {
        user
    }
}

//protocol UserCaching: Sendable {
//    func getUser(id: String) async -> User?
//    func setUser(_ user: User) async
//}
//
//// アクター実装
//actor UserMemoryCache2: UserCaching {
//    private var cache: [String: User] = [:]
//    
//    func getUser(id: String) -> User? {
//        cache[id]
//    }
//    
//    func setUser(_ user: User) {
//        cache["1"] = user
//    }
//}
