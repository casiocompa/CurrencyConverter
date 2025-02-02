//
//  APIRequest.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import Foundation

// MARK: - Request
struct APIRequest {
    let urlRequest: URLRequest
    
    init?(config: APIConfiguration) {
        guard var urlComponents = URLComponents(string: config.endpoint) else { return nil }
        
        if let parameters = config.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents.url else { return nil }
        
        var request = URLRequest(
            url: finalURL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: config.timeInterval
        )
        
        request.httpMethod = config.method.rawValue
        request.allHTTPHeaderFields = config.headers
        request.httpBody = config.body.flatMap { try? JSONEncoder().encode($0) }
        
        self.urlRequest = request
    }
}
