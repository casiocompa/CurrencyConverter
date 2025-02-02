//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import UIKit

enum Currency: String, CaseIterable {
    case UAH
    case USD
    case EUR
    case GBP
    case PLN
    case CHF

    static var defaultCode: String {
        return Currency.UAH.rawValue
    }
    
    var codes: [String] {
        switch self {
        case .UAH:
            return ["UAH"]
        case .USD:
            return ["USD"]
        case .EUR:
            return ["EUR"]
        case .GBP:
            return ["GBP"]
        case .PLN:
            return ["PLN"]
        case .CHF:
            return ["CHF"]
        }
    }

    var symbol: String {
        switch self {
        case .UAH:
            return "₴"
        case .USD:
            return "$"
        case .EUR:
            return "€"
        case .GBP:
            return "£"
        case .PLN:
            return "zł"
        case .CHF:
            return "₣"
        }
    }
    
    var shortName: String {
        switch self {
        case .UAH:
            return "UAH"
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .GBP:
            return "GBP"
        case .PLN:
            return "PLN"
        case .CHF:
            return "CHF"
        }
    }
    
    
    var description: String {
        switch self {
        case .UAH:
            return Localization.currency_description_uah.description
        case .USD:
            return Localization.currency_description_usd.description
        case .EUR:
            return Localization.currency_description_eur.description
        case .GBP:
            return Localization.currency_description_gbp.description
        case .PLN:
            return Localization.currency_description_pln.description
        case .CHF:
            return Localization.currency_description_chf.description
        }
    }

    
    var flagImage: UIImage? {
       return UIImage(named: rawValue)
    }
    
    var flagImageName: String? {
       return rawValue
    }
    
    private static var codesMap: [String: Currency] = {
        var map = [String: Currency]()
        
        Currency.allCases.forEach { currency in
            currency.codes.forEach { code in
                map[code.uppercased()] = currency
            }
        }
        return map
    }()

    
}

//MARK: - Static Mehods
extension Currency {
    static func getSymbol(currencyCode: String?) -> String {
        return getCurrency(currencyCode: currencyCode)?.symbol ?? currencyCode ?? ""
    }

    static func getCurrency(currencyCode: String?) -> Currency? {
        guard let code = currencyCode?.uppercased() else {
            return nil
        }
        return codesMap[code]
    }
    
    static func avalibleCurrencies() -> [Currency] {
        return Currency.allCases.filter {
            Config.availableСurrencies.contains($0)
        }
    }
    
    static func avalibleCurrenciesList() -> [String: Currency] {
        return codesMap.filter {
            Config.availableСurrencies.contains($0.value)
        }
    }
}
