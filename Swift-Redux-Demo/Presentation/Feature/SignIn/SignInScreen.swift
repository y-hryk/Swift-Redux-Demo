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
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0.0) {
                Text("Demo App")
                    .fontWeight(.bold)
                    .font(.title50())
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.body50())
                        .padding(.horizontal, 32)
                    TextField("Username", text: Binding(get: {
                        store.state.userName
                    }, set: { value, _ in
                        Task {
                            await store.dispatch(SignInStateAction.userNameUpdated(value))
                        }
                    }))
                    .font(.textField50())
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.Background.textField))
                    .padding(.horizontal, 32)
                    
                    Spacer().frame(height: 20)
                    Text("Password")
                        .font(.body50())
                        .padding(.horizontal, 32)
                    SecureField("Password", text: Binding(get: {
                        store.state.password
                    }, set: { value, _ in
                        Task {
                            await store.dispatch(SignInStateAction.passwordUpdated(value))
                        }
                    }))
                    .font(.textField50())
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.Background.textField))
                    .padding(.horizontal, 32)
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
    let store = LocalStoreBuilder
        .stub(state: SignInState.preview())
        .build()
    let globalStore = Redux.GlobalStore(
        initialState: ApplicationState.preview(),
        reducer: ApplicationState.reducer
    )
    SignInScreen(store: store, actionCreator: ActionCreatorAssembler().resolve())
        .environment(\.globalStore, globalStore)
}
