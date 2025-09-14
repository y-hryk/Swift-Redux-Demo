//
//  StateBinding.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/05.
//

import SwiftUI
import Combine

@propertyWrapper
@MainActor
struct StateBinding<Value: Equatable>: @preconcurrency DynamicProperty {
    @StateObject private var selector: StateSelector<Value>
    @Environment(\.globalStore) private var globalStore
    
    private let keyPath: KeyPath<ApplicationState, Value>
    private let defaultValue: Value
    
    init(_ keyPath: KeyPath<ApplicationState, Value>, default defaultValue: Value) {
        self.keyPath = keyPath
        self.defaultValue = defaultValue
        self._selector = StateObject(wrappedValue: StateSelector(defaultValue: defaultValue))
    }
    
    var wrappedValue: Value {
        selector.value
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: {
                selector.value
            },
            set: { newValue in
                Task { @MainActor in
                    selector.value = newValue
                }
            }
        )
    }
    
    func update() {
        guard let store = globalStore else { return }
        Task { @MainActor in
            selector.connectIfNeeded(to: store, keyPath: keyPath)
        }
    }
}

// MARK: - ModifierStateSelector (内部実装)
class StateSelector<Value: Equatable>: ObservableObject {
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
