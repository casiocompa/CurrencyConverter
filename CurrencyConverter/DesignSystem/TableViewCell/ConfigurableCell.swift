//
//  ConfigurableCell.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

protocol ConfigurableCell: ReusableCell {
    associatedtype Model
    
    func configure(with model: Model, isSelected: Bool)
}