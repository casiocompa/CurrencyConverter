//
//  ViewUtils.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

extension UIView {
    
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
