//
//  StateModifierBindings.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/05.
//

import SwiftUI
import Combine

@MainActor
class ModifierStateSelector<Value: Equatable>: ObservableObject {
    @Published var value: Value
    private var cancellable: AnyCancellable?
    private var isConnected = false
    
    init(defaultValue: Value) {
        self.value = defaultValue
    }
    
    func connectIfNeeded(to store: Redux.GlobalStore, keyPath: KeyPath<GlobalState, Value>) {
        guard !isConnected else { return }
        isConnected = true
        
        // ObservableObjectPublisherを直接監視
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
        
        // 初期値を設定
        Task { @MainActor in
            self.value = store.state[keyPath: keyPath]
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

// MARK: - StateObservationBuilder (Pattern 2)
@MainActor
class StateObservationBuilder: ObservableObject {
    private let store: Redux.GlobalStore
    private var selectors: [String: Any] = [:]
    
    init(store: Redux.GlobalStore) {
        self.store = store
    }
    
    func getSelector<Value: Equatable>(
        for keyPath: KeyPath<GlobalState, Value>,
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
    
    func observeState<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value>,
        defaultValue: Value,
        perform action: @escaping (Value) -> Void
    ) -> AnyPublisher<Value, Never> {
        let selector = getSelector(for: keyPath, defaultValue: defaultValue)
        return selector.$value.eraseToAnyPublisher()
    }
}

// MARK: - View Extensions (汎用的な実装)
extension View {
    // 完全に汎用的なメソッド（デフォルト値必須）
    func observeState<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value>,
        from builder: StateObservationBuilder,
        default defaultValue: Value,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        self.onReceive(
            builder.observeState(keyPath, defaultValue: defaultValue) { _ in }
        ) { value in
            action(value)
        }
    }
    
    // Optional値専用（デフォルト値はnil）
    func observeOptionalState<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value?>,
        from builder: StateObservationBuilder,
        perform action: @escaping (Value?) -> Void
    ) -> some View {
        self.observeState(keyPath, from: builder, default: nil as Value?) { value in
            action(value)
        }
    }
    
    // ViewModifierスタイル（チェーン可能）
    func observingState<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value>,
        from builder: StateObservationBuilder,
        default defaultValue: Value,
        into binding: Binding<Value>
    ) -> some View {
        self.observeState(keyPath, from: builder, default: defaultValue) { value in
            binding.wrappedValue = value
        }
    }
    
    // 複数の状態を一度に監視
    func observingStates(
        from builder: StateObservationBuilder,
        @StateModifierBuilder _ observations: () -> [StateModifierObservation]
    ) -> some View {
        var modifiedView: AnyView = AnyView(self)
        
        for observation in observations() {
            modifiedView = AnyView(observation.apply(modifiedView, builder))
        }
        
        return modifiedView
    }
}

// MARK: - StateModifierObservation（複数状態監視用のヘルパー）
struct StateModifierObservation {
    let apply: (AnyView, StateObservationBuilder) -> AnyView
}

@resultBuilder
struct StateModifierBuilder {
    static func buildBlock(_ observations: StateModifierObservation...) -> [StateModifierObservation] {
        Array(observations)
    }
}

extension StateModifierObservation {
    static func observe<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value>,
        default defaultValue: Value,
        into binding: Binding<Value>
    ) -> StateModifierObservation {
        StateModifierObservation { view, builder in
            AnyView(
                view.observeState(keyPath, from: builder, default: defaultValue) { value in
                    binding.wrappedValue = value
                }
            )
        }
    }
    
    static func observe<Value: Equatable>(
        _ keyPath: KeyPath<GlobalState, Value?>,
        into binding: Binding<Value?>
    ) -> StateModifierObservation {
        StateModifierObservation { view, builder in
            AnyView(
                view.observeOptionalState(keyPath, from: builder) { value in
                    binding.wrappedValue = value
                }
            )
        }
    }
}

// MARK: - Convenience Bindings (Pattern 2)
struct StateModifierBindings {
    static func binding<Value: Equatable>(to state: Binding<Value>) -> Binding<Value> {
        state
    }
}
