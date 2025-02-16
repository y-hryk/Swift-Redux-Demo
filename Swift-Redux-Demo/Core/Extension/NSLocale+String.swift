//
//  NSLocale+String.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/23.
//

import Foundation

extension NSLocale {
    static func localeString() -> String {
        let language = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first
        return language ?? "en"
    }
}
