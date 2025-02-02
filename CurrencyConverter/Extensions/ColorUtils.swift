//
//  ColorUtils.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import UIKit

extension UIColor {

    static func performSystemColor(named: String) -> UIColor? {
        let selector = NSSelectorFromString(named)
        if UIColor.responds(to: selector),
           let color = UIColor.perform(selector).takeUnretainedValue() as? UIColor {
            return color
        }
        return nil
    }
}
