//
//  UserRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import Foundation

protocol UserRepository: Sendable {
    func isSignIn() async throws -> Bool
    func signIn() async throws -> Void
    func getUsers() async throws -> User
    func signOut() async throws -> Void
}

struct UserRepositoryImpl: UserRepository, Injectable {
    struct Dependency {
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func isSignIn() async throws -> Bool {
        await UserMemoryCache.shared.getUser().isSignIn
    }
    
    func signIn() async throws -> Void {
        await UserMemoryCache.shared.signIn()
    }
    
    func signOut() async throws -> Void {
        await UserMemoryCache.shared.signout()
    }
    
    func getUsers() async throws -> User {
        await UserMemoryCache.shared.getUser()
    }
}
