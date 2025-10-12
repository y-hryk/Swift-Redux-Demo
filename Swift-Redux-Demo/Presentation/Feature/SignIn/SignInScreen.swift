//
//  SignInScreen.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/17.
//

import SwiftUI

struct SignInScreen: View {
    @StateObject var store: Redux.LocalStore<SignInState>
    let actionCreator: SignInStateActionCreator<SignInState>
    
    init(state: SignInState,
         actionCreator: SignInStateActionCreator<SignInState>,
         type: Redux.LocalStoreType = .normal) {
        _store = StateObject(wrappedValue: LocalStoreBuilder.create(initialState: state, type: type)
            .build()
        )
        self.actionCreator = actionCreator
    }
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0.0) {
                Text("Demo App")
                    .font(.title75())
                    .foregroundStyle(Color.Text.body)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Username")
                            .font(.body50())
                            .foregroundStyle(Color.Text.body)
                            .padding(.horizontal, 32)
                        TextField("Username", text: Binding(get: {
                            store.state.userName
                        }, set: { value, _ in
                            Task {
                                await store.dispatch(SignInStateAction.userNameUpdated(value))
                            }
                        }))
                        .foregroundStyle(Color.Text.body)
                        .font(.textField50())
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.Background.textField))
                        .padding(.horizontal, 32)
                    }
                    
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Password")
                            .font(.body50())
                            .foregroundStyle(Color.Text.body)
                            .padding(.horizontal, 32)
                        SecureField("Password", text: Binding(get: {
                            store.state.password
                        }, set: { value, _ in
                            Task {
                                await store.dispatch(SignInStateAction.passwordUpdated(value))
                            }
                        }))
                        .font(.textField50())
                        .foregroundStyle(Color.Text.body)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.Background.textField))
                        .padding(.horizontal, 32)
                    }
                }
                .frame(height: 200)
                
                PrimaryButton(title: "SignIn (dummy)") {
                    Task {
                        await store.dispatch(actionCreator.signIn())
                    }
                }
                .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Background.main)
            
            CircularProgressBar(progress: Binding(
                get: { CGFloat(store.state.progress) },
                set: { value, _ in
                    Task {
                        await store.dispatch(SignInStateAction.progressUpdated(Float(value)))
                    }
                }), color: Color(red: 138 / 255, green: 111 / 255, blue: 245 / 255, opacity:1.0))
                .hidden(!store.state.showProgress)
        }
    }
}

#Preview {
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    SignInScreen(state: SignInState.preview(),
                 actionCreator: SignInStateActionCreator(),
                 type: .stub)
        .environment(\.globalStore, globalStore)
}
