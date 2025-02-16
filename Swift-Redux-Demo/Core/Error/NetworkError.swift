//
//  NetworkError.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/03.
//

import UIKit

enum NetworkError: ApplicationError {
    case unauthorized
    case serviceUnavailable
    case badRequest(code: Int, message: String)
    case server(code: Int)
    case unknown
    
    var title: String {
        switch self {
        case .unauthorized:
            return "StatusCode 401"
        case .serviceUnavailable:
            return "StatusCode 503"
        case .badRequest(let code, _):
            return "StatusCode \(code)"
        case .server(let code):
            return "StatusCode \(code)"
        case .unknown:
            return "Network Error Unknown"
        }
    }
    var message: String {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .serviceUnavailable:
            return "ServiceUnavailable"
        case .badRequest(_, let message):
            return message
        case .server:
            return "Internal Server Error"
        case .unknown:
            return ""
        }
    }
}
