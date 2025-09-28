//
//  StateModifierBindings.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/05.
//

import SwiftUI
import Combine

// MARK: - ModifierStateSelector (内部実装)
class ModifierStateSelector<Value: Equatable>: ObservableObject {
    @Published var value: Value
    private var cancellable: AnyCancellable?
    private var isConnected = false
    
    init(defaultValue: Value) {
        self.value = defaultValue
    }
    
    @MainActor
    func connectIfNeeded(to store: Redux.GlobalStore, keyPath: KeyPath<ApplicationState, Value>) {
        guard !isConnected else { return }
        isConnected = true
        
        // 初期値を設定
        self.value = store.state[keyPath: keyPath]
        
        // ObservableObjectPublisherを監視
        cancellable = store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak store] _ in
                guard let self = self, let store = store else { return }
                
                Task { @MainActor in
                    let newValue = store.state[keyPath: keyPath]
                    if self.value != newValue {
                        self.value = newValue
                    }
                }
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

// MARK: - StateModifierObservation (監視定義)
struct StateModifierObservation {
    let apply: @MainActor (AnyView, StateObservationBuilder) -> AnyView
}

// MARK: - StateObservationBuilder (メインクラス - APIを提供)
@MainActor
class StateObservationBuilder: ObservableObject {
    private let store: Redux.GlobalStore
    private var selectors: [String: Any] = [:]
    
    init(store: Redux.GlobalStore) {
        self.store = store
    }
    
    private func getSelector<Value: Equatable>(
        for keyPath: KeyPath<ApplicationState, Value>,
        defaultValue: Value
    ) -> ModifierStateSelector<Value> {
        let key = String(describing: keyPath)
        
        if let existingSelector = selectors[key] as? ModifierStateSelector<Value> {
            return existingSelector
        }
        
        let selector = ModifierStateSelector(defaultValue: defaultValue)
        selector.connectIfNeeded(to: store, keyPath: keyPath)
        selectors[key] = selector
        
        return selector
    }
    
    // MARK: - Public API Methods
    
    // 通常の値用
    func observe<Value: Equatable>(
        _ keyPath: KeyPath<ApplicationState, Value>,
        default defaultValue: Value,
        into binding: Binding<Value>
    ) -> StateModifierObservation {
        StateModifierObservation { @MainActor view, builder in
            let selector = builder.getSelector(for: keyPath, defaultValue: defaultValue)
            
            return AnyView(
                view.onReceive(selector.$value.receive(on: DispatchQueue.main)) { value in
                    binding.wrappedValue = value
                }
            )
        }
    }
    
    // Optional値用（デフォルト値はnil）
    func observe<Value: Equatable>(
        _ keyPath: KeyPath<ApplicationState, Value?>,
        into binding: Binding<Value?>
    ) -> StateModifierObservation {
        StateModifierObservation { @MainActor view, builder in
            let selector = builder.getSelector(for: keyPath, defaultValue: nil as Value?)
            
            return AnyView(
                view.onReceive(selector.$value.receive(on: DispatchQueue.main)) { value in
                    binding.wrappedValue = value
                }
            )
        }
    }
    
    // アクション実行用（バインディングなし）
    func observe<Value: Equatable>(
        _ keyPath: KeyPath<ApplicationState, Value>,
        default defaultValue: Value,
        perform action: @escaping (Value) -> Void
    ) -> StateModifierObservation {
        StateModifierObservation { @MainActor view, builder in
            let selector = builder.getSelector(for: keyPath, defaultValue: defaultValue)
            
            return AnyView(
                view.onReceive(selector.$value.receive(on: DispatchQueue.main), perform: action)
            )
        }
    }
    
    // Optional値でアクション実行用
    func observe<Value: Equatable>(
        _ keyPath: KeyPath<ApplicationState, Value?>,
        perform action: @escaping (Value?) -> Void
    ) -> StateModifierObservation {
        StateModifierObservation { @MainActor view, builder in
            let selector = builder.getSelector(for: keyPath, defaultValue: nil as Value?)
            
            return AnyView(
                view.onReceive(selector.$value.receive(on: DispatchQueue.main), perform: action)
            )
        }
    }
}

// MARK: - StateModifierBuilder (Result Builder)
@resultBuilder
struct StateModifierBuilder {
    static func buildBlock(_ observations: StateModifierObservation...) -> [StateModifierObservation] {
        Array(observations)
    }
}

// MARK: - View Extension
extension View {
    @MainActor
    func observingStates(
        from builder: StateObservationBuilder,
        @StateModifierBuilder _ observations: (StateObservationBuilder) -> [StateModifierObservation]
    ) -> some View {
        var modifiedView: AnyView = AnyView(self)
        
        for observation in observations(builder) {
            modifiedView = observation.apply(modifiedView, builder)
        }
        
        return modifiedView
    }
}

/*
 example:
 
 // root
 @main
 struct DemoApp: App {
     @StateObject private var stateObservationBuilder: StateObservationBuilder
     
     init() {
        _stateObservationBuilder = StateObject(wrappedValue: StateObservationBuilder(store: globalStore))
     }
 
     var body: some Scene {
         WindowGroup {
             AppRootScreen()
             .environmentObject(stateObservationBuilder)
         }
     }
 }

 struct ContentView: View {
    @EnvironmentObject var stateObservationBuilder: StateObservationBuilder
    @State private var userName: String = ""
    @State private var password: String = ""
 
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(userName)
            Text(password)
        }
        .observingStates(from: stateObservationBuilder) { builder in
            // Bind the variables you want to monitor from ApplicationState
            builder.observe(\.userName, default: "", into: $userName)
            builder.observe(\.password, default: "", into: $password)
        }
    }
 }
 */
