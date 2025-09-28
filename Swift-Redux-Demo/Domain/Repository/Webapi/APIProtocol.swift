//
//  APIProtocol.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/27.
//

import Foundation

enum HTTPMethod: String {
    case get, post, patch, delete
}

protocol APIProtocol {
    associatedtype ResponseType
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
}

extension APIProtocol {
    var baseURL: URL {
        URL(string: "")!
    }
    var headers: [String : String]? {
        [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
}

protocol APIRequestProtocol: APIProtocol {
    var parameters: [String: String]? { get }
}
