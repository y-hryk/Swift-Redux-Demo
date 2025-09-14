//
//  InjectionKey.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/02.
//

import Foundation

// MARK: - InjectionKey Protocol
public protocol InjectionKey {
    associatedtype Value: Sendable
    static var currentValue: Self.Value { get set }
}

// MARK: - Thread-Safe Storage
final class InjectionStorage: @unchecked Sendable {
    static let shared = InjectionStorage()
    let lock = NSLock()
    var values: [String: any Sendable] = [:]
    
    private init() {}
    
    func getValue<K: InjectionKey>(for keyType: K.Type) -> K.Value {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: keyType)
        if let value = values[key] as? K.Value {
            return value
        }
        return keyType.currentValue
    }
    
    func setValue<K: InjectionKey>(_ value: K.Value, for keyType: K.Type) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: keyType)
        values[key] = value
    }
}

// MARK: - InjectedValues
struct InjectedValues: Sendable {
    nonisolated(unsafe) private static var current = InjectedValues()
    
    static subscript<K: InjectionKey>(key: K.Type) -> K.Value {
        get { InjectionStorage.shared.getValue(for: key) }
        set { InjectionStorage.shared.setValue(newValue, for: key) }
    }
    
    static subscript<T: Sendable>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

// MARK: - Injected Property Wrapper
@propertyWrapper
struct Injected<T: Sendable>: @unchecked Sendable {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

//#if DEBUG
//extension InjectedValues {
//    static func setupMocks() {
//        InjectedValues[\.userRepository] = MockUserRepository()
//        InjectedValues[\.movieRepository] = MockMovieRepository()
//        InjectedValues[\.favoriteRepository] = MockFavoriteRepository()
//        InjectedValues[\.maintenanceRepository] = MockMaintenanceRepository()
//        InjectedValues[\.personRepository] = MockPersonRepository()
//    }
//    
//    static func resetToDefaults() {
//        InjectedValues[\.userRepository] = UserRepositoryImpl(with: UserRepositoryImpl.Dependency())
//        InjectedValues[\.movieRepository] = MovieRepositoryImpl(with: MovieRepositoryImpl.Dependency())
//        InjectedValues[\.favoriteRepository] = FavoriteRepositoryImpl(
//            with: FavoriteRepositoryImpl.Dependency(dataStore: FavoriteMemoryCache.shared)
//        )
//        InjectedValues[\.maintenanceRepository] = MaintenanceRepositoryImpl()
//        InjectedValues[\.personRepository] = PersonRepositoryImpl(with: PersonRepositoryImpl.Dependency())
//    }
//}
//#endif
