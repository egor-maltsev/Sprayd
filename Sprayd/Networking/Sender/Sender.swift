//
//  Sender.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 07.04.2026.
//

import Foundation

final class Sender {
    
    // TODO: add server base url
    private enum Keys {
        static let baseURL = "SERVER_BASE_URL"
    }
    
    private static let delays: [TimeInterval] = [1, 3, 10]
    
    static func send<T: Codable>(endpoint: String,
                                 method: HTTPMethod,
                                 headers: [String: String]? = nil,
                                 body: Data? = nil) async throws -> SuccessResponse<T> {
        guard let base = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String else {
            fatalError("Can't get baseURL")
        }
        guard let url = URL(string: "\(base)\(endpoint)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return try await sendWithRetry(request: request,
                                    endpoint: endpoint,
                                    method: method,
                                    headers: headers,
                                    body: body,
                                    attempt: 0
        )
    }
    
    private static func sendWithRetry<T: Codable>(request: URLRequest,
                                                  endpoint: String,
                                                  method: HTTPMethod,
                                                  headers: [String: String]?,
                                                  body: Data?,
                                                  attempt: Int) async throws -> SuccessResponse<T> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            return try await handleResponse(
                http,
                data: data,
                request: request,
                endpoint: endpoint,
                method: method,
                headers: headers,
                body: body,
                attempt: attempt
            )
        } catch {
            // If we have network errors -> retry
            if attempt < delays.count {
                try await Task.sleep(nanoseconds: UInt64(delays[attempt] * 1_000_000_000))
                return try await sendWithRetry(
                    request: request,
                    endpoint: endpoint,
                    method: method,
                    headers: headers,
                    body: body,
                    attempt: attempt + 1
                )
            } else {
                throw APIError.networkError(error)
            }
        }
    }
    
    private static func handleResponse<T: Codable>(_ response: HTTPURLResponse,
                                                   data: Data,
                                                   request: URLRequest,
                                                   endpoint: String,
                                                   method: HTTPMethod,
                                                   headers: [String: String]?,
                                                   body: Data?,attempt: Int) async throws -> SuccessResponse<T> {
        switch response.statusCode {
        case 200...299:
            return try decodeResponse(data)
        case 401:
            // TODO: refresh logic
            throw try decodeErrorResponse(data)
        case 500...599:
            if attempt < delays.count {
                try await Task.sleep(nanoseconds: UInt64(delays[attempt] * 1_000_000_000))
                return try await sendWithRetry(
                    request: request,
                    endpoint: endpoint,
                    method: method,
                    headers: headers,
                    body: body,
                    attempt: attempt + 1
                )
            } else {
                throw try decodeErrorResponse(data)
            }
        default:
            throw try decodeErrorResponse(data)
        }
    }
    
    private static func decodeResponse<T: Codable>(_ data: Data) throws -> SuccessResponse<T> {
        do {
            return try JSONDecoder().decode(SuccessResponse<T>.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    private static func decodeErrorResponse(_ data: Data) throws -> APIErrorResponse {
        do {
            return try JSONDecoder().decode(APIErrorResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
