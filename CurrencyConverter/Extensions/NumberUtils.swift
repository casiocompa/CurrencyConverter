//
//  NumberUtils.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import Foundation

extension Double {
    
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = Config.decimalSeparator
        return formatter.string(for: self) ?? self.description
    }
    
    func convertToCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        return formatter.string(for: self) ?? self.description
    }
    
    func convertToCoinsAmount() -> Int64 {
        let amount = Double(self * 100).nextUp
        return Int64(amount)
    }
    
    func convertToRateFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 4
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = Config.decimalSeparator
        return formatter.string(for: self) ?? self.description
    }
    
}

extension Optional where Wrapped == Double {
    var isNilOrEmpty: Bool {
        self == nil || self == 0
    }
    
    var isNilOrEmptyValue: Double? {
        if self == nil || self == 0 {
            return nil
        }else{
            return self
        }
    }
}

extension Double {
    var isEmpty: Bool {
        self == 0
    }
    
    var isEmptyOrValue: Double? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}
