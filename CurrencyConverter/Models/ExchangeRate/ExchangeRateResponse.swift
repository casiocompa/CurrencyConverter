//
//  ExchangeRateResponse.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

struct ExchangeRateResponse: Decodable {
    let amount: Double
    let currency: String

   private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let amountString = try container.decodeIfPresent(String.self, forKey: .amount) {
            self.amount = Double(amountString) ?? 0.0
        } else {
            self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        }
        self.currency = try container.decode(String.self, forKey: .currency)
    }
}

extension ExchangeRateResponse {
    func convertToModel() -> ExchangeRateModel {
        return ExchangeRateModel(
            amount: amount,
            currency: currency
        )
    }
}