//
//  ApplicationError.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

// MARK: - Application Error
enum ApplicationError: Swift.Error {
    case decodingFailure
    case networkUnreachable
    case external(code: Int?, message: String?, title: String?)
    case unknown
}