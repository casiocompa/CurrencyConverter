//
//  HTTPMethod.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import Foundation
import OSLog

// MARK: - Typealiases
typealias Parameters = [String: String]
typealias Headers = [String: String]

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET, POST
}

// MARK: - Request Content Type
enum RequestContentType: String {
    case json = "application/json"
}

// MARK: - Request Header Field
enum RequestHeaderField: String {
    case contentType = "Content-Type"
}

// MARK: - API Configuration
protocol APIConfiguration {
    var method: HTTPMethod { get }
    var path: String { get }
    var endpoint: String { get }
    var timeInterval: TimeInterval { get }
    var body: Encodable? { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var contentType: RequestContentType? { get }
}

extension APIConfiguration {
    var timeInterval: TimeInterval { NetworkConfig.timeInterval }
    var endpoint: String { NetworkConfig.apiEndpoint + path }
    var body: Encodable? { nil }
    var headers: Headers? { nil }
    var parameters: Parameters? { nil }
    var contentType: RequestContentType? { nil }
}

// MARK: - Public Methods
extension APIConfiguration {
    
    func execute<T: Decodable>(_ success: T.Type) async throws -> T {
        guard let request = APIRequest(config: self) else {
            logWarning("Bad URL: \(URLError(.badURL).localizedDescription)")
            throw URLError(.badURL)
        }
        
        logInfo("***************************************************************")
        logInfo("Request.url: \n \(request.urlRequest.debugDescription) \n")
        
        do {
            let (response, data) = try await dataTask(with: request.urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                try await self.validateFail(response, data: data)
            
                return try await execute(success)
            }
            
            return try decodeResponse(data, response: response)
        } catch let urlError as URLError {
            logWarning("Network error: \(urlError.localizedDescription)")
            throw ApplicationError.networkUnreachable
        } catch let error {
            logWarning("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Private Methods
extension APIConfiguration {
    
    private func dataTask(with urlRequest: URLRequest) async throws -> (URLResponse, Data) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let response = response, let data = data {
                    continuation.resume(returning: (response, data))
                } else {
                    continuation.resume(throwing: ApplicationError.unknown)
                }
            }
            task.resume()
        }
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data, response: URLResponse) throws -> T {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            logInfo("Success ✅: \(response.debugDescription)\n | Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
            return decodedResponse
        } catch {
            logWarning("Decoding error: \(error.localizedDescription)")
            throw ApplicationError.decodingFailure
        }
    }
    
    private func validateFail(_ response: URLResponse, data: Data) async throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApplicationError.unknown
        }
        
        do {
            let errorModel = try JSONDecoder().decode(GeneralErrorModel.self, from: data)
            logWarning("External error: Code \(httpResponse.statusCode) | \(errorModel.error) - \(errorModel.description)")
            throw ApplicationError.external(
                code: httpResponse.statusCode,
                message: errorModel.description,
                title: errorModel.error
            )
        } catch let decodingError as ApplicationError {
            throw decodingError
        } catch let error {
            logWarning("Decoding failure during error handling: \(error.localizedDescription)")
            throw ApplicationError.decodingFailure
        }
    }
    
    private func logInfo(_ message: String) {
        Logger.network.info("ℹ️ \(message)")
    }
    
    private func logWarning(_ message: String) {
        Logger.network.warning("⚠️ \(message)")
    }
}
