//
//  StringUtils.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

extension String {
    
    func toAmountDouble() -> Double? {
        return convertAmountTo()?.doubleValue
    }
        
    private func convertAmountTo() -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        formatter.decimalSeparator = "."
        if let number = formatter.number(from: self.replacingOccurrences(of: " ", with: "")) {
            return number
        }
        
        formatter.decimalSeparator = ","
        return formatter.number(from: self.replacingOccurrences(of: " ", with: ""))
    }
    
}

extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
    
    var isNilOrEmptyValue: String? {
        if self == nil || self == "" {
            return nil
        }else{
            return self
        }
    }
}