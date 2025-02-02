//
//  ExchangeRateServiceNetworkProtocol.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation

protocol ExchangeRateServiceNetworkProtocol {
    static func fetchExchangeRates(
        model: ExchangeRateRequest,
        result: @escaping (ExchangeRateResult) -> Void
    )
}

final class ExchangeRateService: ExchangeRateServiceNetworkProtocol {
    
    static func fetchExchangeRates(
        model: ExchangeRateRequest,
        result: @escaping (ExchangeRateResult) -> Void
    ) {
        Task {
            do {
                let response = try await ExchangeRateServiceEndpoint
                    .exchange(data: model)
                    .execute(ExchangeRateResponse.self)
                
                result(
                    .success(response.convertToModel())
                )
            } catch let error as ApplicationError {
                result(.failure(error))
            } catch {
                result(
                    .failure(
                        ApplicationError.external(
                            code: nil,
                            message: error.localizedDescription,
                            title: nil
                        )
                    )
                )
            }
        }
    }
    
}

// MARK: - APIConfiguration
private enum ExchangeRateServiceEndpoint: APIConfiguration {
    
    case exchange(data: ExchangeRateRequest)
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String {
        switch self {
        case .exchange(let model):
            return "/currency/commercial/exchange/\(model.fromAmount)-\(model.fromCurrency)/\(model.toCurrency)/latest"
        }
    }
}
