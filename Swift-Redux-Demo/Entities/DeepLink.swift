//
//  DeepLink.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/08/04.
//

import Foundation

struct DeepLink: Equatable {
    enum To: Equatable {
        case movieList
        case watchList
        case movieDetail(MovieId)
        case firstModal
    }
    let to: DeepLink.To
    
    static func handleDeepLink(url: URL, isSignIn: Bool) -> DeepLink? {
        if isSignIn { return nil }
        let host = url.host() ?? ""
        let query = url.queryParameters
        switch host {
        case "movieList":
            if let id = query?["id"] {
                return DeepLink(to: DeepLink.To.movieDetail(MovieId(value: id)))
            }
            return DeepLink(to: DeepLink.To.movieList)
        case "watchList":
            return DeepLink.init(to: DeepLink.To.watchList)
        case "firstModal":
            return DeepLink.init(to: DeepLink.To.firstModal)
        default:
            return nil
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
