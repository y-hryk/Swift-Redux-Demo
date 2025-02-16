import Foundation

enum AsyncValue<Element> {
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

extension AsyncValue: Equatable {
    static func == (lhs: AsyncValue<Element>, rhs: AsyncValue<Element>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        default: return false
        }
    }
}
