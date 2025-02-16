//
//  UserRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import Foundation

protocol UserRepository {
    func isSignIn() async throws -> Bool
    func signIn() async throws -> Void
    func getUsers() async throws -> User
    func signOut() async throws -> Void
    mutating func update(user: User) async throws -> User
}

struct UserRepositoryImpl: UserRepository, Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func isSignIn() async throws -> Bool {
        UserMemoryCache.shared.user.isSignIn
    }
    
    func signIn() async throws -> Void {
        UserMemoryCache.shared.user.isSignIn = true
    }
    
    func signOut() async throws -> Void {
        UserMemoryCache.shared.user.isSignIn = false
    }
    
    func getUsers() async throws -> User {
        UserMemoryCache.shared.user
    }
    
    mutating func update(user: User) async throws -> User {
        UserMemoryCache.shared.user = user
        return user
    }
}
