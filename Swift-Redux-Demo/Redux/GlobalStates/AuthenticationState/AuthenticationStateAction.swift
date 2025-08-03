//
//  AuthenticationStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/19.
//

import UIKit

enum AuthenticationStateAction: Redux.GlobalAction {
    case changeAuthenticated(isAuthenticated: Bool)
    case signOutStart
}

struct AuthenticationStateActionCreator<State: Redux.State> {
    @Injected(\.userRepository) private var userRepository: UserRepository
    
    func isSignIn() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                try? await Task.sleep(for: .seconds(3))
                let isSignIn = try await userRepository.isSignIn()
                if isSignIn {
                    return GlobalStateAction.update(startScreen: .signedIn)
                } else {
                    return GlobalStateAction.update(startScreen: .signedOut)
                }
            } catch _ {
                await store.dispatch(AuthenticationStateAction.changeAuthenticated(isAuthenticated: false))
                return GlobalStateAction.update(startScreen: .signedOut)
            }
        }, className: "\(type(of: self))")
    }
    
    func signOut() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                try await userRepository.signOut()
                await store.dispatch(AuthenticationStateAction.changeAuthenticated(isAuthenticated: false))
                return GlobalStateAction.update(startScreen: .splash)
            } catch {
                return GlobalStateAction.update(startScreen: .splash)
            }
        }, className: "\(type(of: self))")
    }
}
