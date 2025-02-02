//
//  Assets.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

enum Assets {
    enum Images: String {
        case arrowUpArrowDown
        case chevronDown
        
        func image() -> UIImage? {
            if let customImage = UIImage(named: self.convertToSnakeCase()) {
                return customImage
            }
            return UIImage(systemName: self.convertToSnakeCase())
        }
        
        private func convertToSnakeCase() -> String {
            var result = ""
            for (index, character) in self.rawValue.enumerated() {
                if character.isUppercase {
                    if index != 0 {
                        result.append(".")
                    }
                    result.append(character.lowercased())
                } else {
                    result.append(character)
                }
            }
            return result
        }
    }
}
