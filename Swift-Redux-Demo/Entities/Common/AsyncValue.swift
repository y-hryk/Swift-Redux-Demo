import Foundation

enum AsyncValue<Element: Equatable & Sendable> {
    case data(value: Element)
    case loading
    case error(error: Error)
    
    var value: Element? {
        switch self {
        case .data(let value): return value
        default: return nil
        }
    }
    
    var error: ApplicationError? {
        switch self {
        case .error(let error):
            return error as? ApplicationError
        default:
            return nil
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .data: return false
        default: return true
        }
    }
}

extension AsyncValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .data(value: let value):
            return ".value(\(type(of: value))"
        case .loading:
            return ".loading"
        case .error(error: let error):
            return "\(error)"
        }
    }
}

extension AsyncValue: Equatable {
    static func == (lhs: AsyncValue<Element>, rhs: AsyncValue<Element>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.data(let a), .data(let b)):
            return a == b
        default: return false
        }
    }
}
