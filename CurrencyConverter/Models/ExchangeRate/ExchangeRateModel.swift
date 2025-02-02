//
//  ExchangeRateModel.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

typealias ExchangeRateResult = Result<ExchangeRateModel, ApplicationError>

struct ExchangeRateModel: Codable {
    let amount: Double
    let currency: String

    var currencyType: Currency? {
        return Currency(rawValue: currency)
    }
    
    init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}