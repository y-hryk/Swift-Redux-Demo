//
//  SignInStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

enum SignInPageStateAction: Redux.Action {
    case updateProgress(Float)
    case showProgress(Bool)
    case updateUserName(String)
    case updatePassword(String)
}

struct SignInPageStateActionCreator<State: Redux.State> {
    @Injected(\.userRepository) private var userRepository: UserRepository
    
    func signIn() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                await store.dispatch(SignInPageStateAction.showProgress(true))
                print(">> showIndicator")
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInPageStateAction.updateProgress(0.25))
                print(">> updateProgress")
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInPageStateAction.updateProgress(0.45))
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInPageStateAction.updateProgress(0.75))
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInPageStateAction.updateProgress(1.0))
                try? await Task.sleep(for: .seconds(1))
                let _ = try await userRepository.signIn()
                await store.dispatch(ToastStateAction.didReceiveToast(
                    Toast(style: .success, message: "Login successful")
                ))
                await store.dispatch(SignInPageStateAction.showProgress(false))
                return GlobalStateAction.update(startScreen: .splash)
            } catch let error {
                await store.dispatch(SignInPageStateAction.showProgress(false))
                return GlobalStateAction.didReceiveError(error)
            }
        }, className: "\(type(of: self))")
    }
}
