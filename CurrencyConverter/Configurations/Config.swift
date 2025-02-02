//
//  Config.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

struct Config {
    static let availableСurrencies: [Currency] = [
        .UAH,
        .USD,
        .EUR,
        .GBP,
        .PLN,
        .CHF
    ]
    
    static var decimalSeparator: String = "."
    static var timeIntervalAutoRefresh: TimeInterval = 10.0
    static var isLoggingEnabled: Bool = false
}
