//
//  ApplicationError.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/02.
//

import Foundation

protocol ApplicationError: Error {
    var title: String { get }
    var message: String { get }
}
