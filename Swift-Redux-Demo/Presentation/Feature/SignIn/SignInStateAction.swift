//
//  SignInStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

enum SignInStateAction: Redux.Action {
    case progressUpdated(Float)
    case progressShown(Bool)
    case userNameUpdated(String)
    case passwordUpdated(String)
}

struct SignInStateActionCreator<State: Redux.State> {
    @Injected(\.userRepository) private var userRepository: UserRepository
    
    func signIn() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                await store.dispatch(SignInStateAction.progressShown(true))
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInStateAction.progressUpdated(0.25))
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInStateAction.progressUpdated(0.45))
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInStateAction.progressUpdated(0.75))
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInStateAction.progressUpdated(1.0))
                try? await Task.sleep(for: .seconds(1))
                let _ = try await userRepository.signIn()
                await store.dispatch(ToastStateAction.didReceiveToast(
                    Toast(style: .success, message: "Login successful")
                ))
                await store.dispatch(SignInStateAction.progressShown(false))
                return ApplicationAction.startScreenChanged(startScreen: .splash)
            } catch let error {
                await store.dispatch(SignInStateAction.progressShown(false))
                return ApplicationAction.errorReceived(error)
            }
        }, className: "\(type(of: self))")
    }
}
