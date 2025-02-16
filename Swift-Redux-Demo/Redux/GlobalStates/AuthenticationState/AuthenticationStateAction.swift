//
//  AuthenticationStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/19.
//

import UIKit

enum AuthenticationStateAction: Action {
    case changeAuthenticated(isAuthenticated: Bool)
    case signOutStart
}

struct AuthenticationStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let userRepository: UserRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func isSignIn() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                try? await Task.sleep(for: .seconds(3))
                let isSignIn = try await dependency.userRepository.isSignIn()
                await store.dispatch(AuthenticationStateAction.changeAuthenticated(isAuthenticated: isSignIn))
                if isSignIn {
                    return GlobalStateAction.update(startScreen: .root)
                } else {
                    return GlobalStateAction.update(startScreen: .onboarding)
                }
            } catch _ {
                await store.dispatch(AuthenticationStateAction.changeAuthenticated(isAuthenticated: false))
                return GlobalStateAction.update(startScreen: .onboarding)
            }
        }, className: "\(type(of: self))")
    }
    
    func signOut() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                try await dependency.userRepository.signOut()
                await store.dispatch(AuthenticationStateAction.changeAuthenticated(isAuthenticated: false))
                return GlobalStateAction.update(startScreen: .splash)
            } catch {
                return GlobalStateAction.update(startScreen: .splash)
            }
        }, className: "\(type(of: self))")
    }
}
