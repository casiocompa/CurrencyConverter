//
//  CurrencyConverterContentViewModel.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

struct CurrencyConverterContentViewModel {
    let isPortraitOrientation: Bool
    let isLoading: Bool
    let fromAmount: String?
    let fromCurrency: Currency
    let fromConversionRate: Double
    
    let toAmount: Double
    let toConversionRate: Double
    let toCurrency: Currency
}
