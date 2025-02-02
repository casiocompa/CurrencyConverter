//
//  ChooseModalModel.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import Foundation

struct ChooseModalModel {
    var iconName: String?
    var title: String?
    var subtitle: String?
    
    init(iconName: String? = nil, title: String? = nil, subtitle: String? = nil) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
    }
}
