//
//  InjectionKey.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/02.
//

public protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value { get set }
}

struct InjectedValues {
    private static var current = InjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
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
