//
//  ExchangeRateRequest.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

struct ExchangeRateRequest: Encodable {
    let fromAmount: String
    let fromCurrency: String
    let toCurrency: String
    
   private enum CodingKeys: String, CodingKey {
        case fromAmount
        case fromCurrency
        case toCurrency
    }
    
    init(
        fromAmount: Double,
        fromCurrency: String,
        toCurrency: String
    ) {
        self.fromAmount = fromAmount.convertToCurrencyString()
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.fromAmount, forKey: .fromAmount)
        try container.encode(self.fromCurrency, forKey: .fromCurrency)
        try container.encode(self.toCurrency, forKey: .toCurrency)
    }
    
}