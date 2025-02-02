//
//  Localization.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

enum Localization: String {
    
    var description: String {
        let localized = String.LocalizationValue(rawValue)
        return String(localized: localized)
    }
    
    //MARK: - Converter
    case select_currency_title
    case from_title
    case to_title
    
    //MARK: - Currency
    case currency_description_uah
    case currency_description_usd
    case currency_description_eur
    case currency_description_gbp
    case currency_description_pln
    case currency_description_chf
    
    //MARK: - Error
    case error_decoding_failure_title
    case error_decoding_failure_description

    case error_network_unreachable_title
    
    case error_external_title
    case error_external_description
    
    case error_unknown_title
    case error_unknown_description

}