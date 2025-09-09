//
//  ID.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/08.
//


protocol ID: Hashable {
    var value: String { get set }
    init(value: Int)
    init(value: String)
}

extension ID {
    init(value: String) {
        self.init(value: value)
    }
    init(value: Int) {
        self.init(value: "\(value)")
    }
}
