//
//  GeneralErrorModel.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import Foundation

struct GeneralErrorModel: Error, Decodable {
    let error: String
    let description: String
    
    enum CodingKeys: String, CodingKey{
        case error = "error"
        case description = "error_description"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(String.self, forKey: .error)
        self.description = try container.decode(String.self, forKey: .description)
    }
}
