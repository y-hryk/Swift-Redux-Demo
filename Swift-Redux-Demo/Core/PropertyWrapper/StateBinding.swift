//
//  StateBinding.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/05.
//

import SwiftUI
import Combine

// MARK: - BindingStateSelector (Pattern 1用)
@MainActor
class BindingStateSelector<Value: Equatable>: ObservableObject {
    @Published var value: Value
    private var cancellable: AnyCancellable?
    private var isConnected = false
    private weak var store: Redux.GlobalStore?
    
    init(defaultValue: Value) {
        self.value = defaultValue
    }
    
    func connectIfNeeded(to store: Redux.GlobalStore, keyPath: KeyPath<ApplicationState, Value>) {
        guard !isConnected else { return }
        isConnected = true
        self.store = store
        
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

// MARK: - Custom Environment Key
struct GlobalStoreKey: EnvironmentKey {
    static let defaultValue: Redux.GlobalStore? = nil
}

extension EnvironmentValues {
    var globalStore: Redux.GlobalStore? {
        get { self[GlobalStoreKey.self] }
        set { self[GlobalStoreKey.self] = newValue }
    }
}

// MARK: - StateBinding Property Wrapper (Pattern 1)
@propertyWrapper
struct StateBinding<Value: Equatable>: DynamicProperty {
    @StateObject private var selector: BindingStateSelector<Value>
    @Environment(\.globalStore) private var globalStore
    private let keyPath: KeyPath<ApplicationState, Value>
    
    init(_ keyPath: KeyPath<ApplicationState, Value>, default defaultValue: Value) {
        self.keyPath = keyPath
        self._selector = StateObject(wrappedValue: BindingStateSelector(defaultValue: defaultValue))
    }
    
    var wrappedValue: Value {
        selector.value
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { selector.value },
            set: { _ in } // 読み取り専用
        )
    }
    
    func update() {
        guard let store = globalStore else { return }
        selector.connectIfNeeded(to: store, keyPath: keyPath)
    }
}

// MARK: - OptionalStateBinding (Pattern 1)
@propertyWrapper
struct OptionalStateBinding<Value: Equatable>: DynamicProperty {
    @StateObject private var selector: BindingStateSelector<Value?>
    @Environment(\.globalStore) private var globalStore
    private let keyPath: KeyPath<ApplicationState, Value?>
    
    init(_ keyPath: KeyPath<ApplicationState, Value?>) {
        self.keyPath = keyPath
        self._selector = StateObject(wrappedValue: BindingStateSelector(defaultValue: nil))
    }
    
    var wrappedValue: Value? {
        selector.value
    }
    
    var projectedValue: Binding<Value?> {
        Binding(
            get: { selector.value },
            set: { _ in } // 読み取り専用
        )
    }
    
    func update() {
        guard let store = globalStore else { return }
        selector.connectIfNeeded(to: store, keyPath: keyPath)
    }
}

// MARK: - Convenience Extensions
extension StateBinding {
    // 非Optional値をOptionalとして扱う場合
    init<T>(_ keyPath: KeyPath<ApplicationState, T>, default defaultValue: T?) where Value == T? {
        self.keyPath = keyPath as! KeyPath<ApplicationState, Value>
        self._selector = StateObject(wrappedValue: BindingStateSelector(defaultValue: defaultValue))
    }
}
