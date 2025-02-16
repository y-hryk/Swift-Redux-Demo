//
//  Injectable.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/08/31.
//

import UIKit

protocol Injectable {
    associatedtype Dependency
    init(with dependency: Dependency)
}

extension Injectable where Dependency == Void {
    init() {
        self.init(with: ())
    }
}
