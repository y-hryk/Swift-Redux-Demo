//
//  AuthenticationStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/19.
//

import UIKit

enum AuthenticationStateAction: Redux.GlobalAction {
    case authStateUpdated(Bool)
    case signOutStarted
}

struct AuthenticationStateActionCreator<State: Redux.State> {
    @Injected(\.userRepository) private var userRepository: UserRepository
    
    func verifyAuthentication() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                try? await Task.sleep(for: .seconds(3))
                let isSignIn = try await userRepository.isSignIn()
                if isSignIn {
                    return ApplicationAction.startScreenChanged(startScreen: .signedIn)
                } else {
                    return ApplicationAction.startScreenChanged(startScreen: .signedOut)
                }
            } catch _ {
                await store.dispatch(AuthenticationStateAction.authStateUpdated(false))
                return ApplicationAction.startScreenChanged(startScreen: .signedOut)
            }
        }, className: "\(type(of: self))")
    }
    
    func signOut() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                try await userRepository.signOut()
                await store.dispatch(AuthenticationStateAction.authStateUpdated(false))
                return ApplicationAction.startScreenChanged(startScreen: .splash)
            } catch {
                return ApplicationAction.startScreenChanged(startScreen: .splash)
            }
        }, className: "\(type(of: self))")
    }
}
