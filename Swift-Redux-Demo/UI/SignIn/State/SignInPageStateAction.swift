//
//  SignInStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import Foundation

enum SignInPageStateAction: Action {
    case updateProgress(Float)
    case showProgress(Bool)
    case updateUserName(String)
    case updatePassword(String)
}

struct SignInPageStateActionCreator<S: ApplicationState> : Injectable {
    struct Dependency {
        let userRepository: UserRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func signIn() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                await store.dispatch(SignInPageStateAction.showProgress(true))
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInPageStateAction.updateProgress(0.25))
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInPageStateAction.updateProgress(0.45))
                try? await Task.sleep(for: .seconds(0.5))
                await store.dispatch(SignInPageStateAction.updateProgress(0.75))
                try? await Task.sleep(for: .seconds(1))
                await store.dispatch(SignInPageStateAction.updateProgress(1.0))
                try? await Task.sleep(for: .seconds(1))
                let _ = try await dependency.userRepository.signIn()
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
