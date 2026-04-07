//
//  ResponseModels.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 07.04.2026.
//

import Foundation

// MARK: - Success Models
struct SuccessResponse<T: Codable>: Codable {
    let data: T
}

// MARK: - Error Models
struct APIErrorResponse: Codable, Error {
    let errorType: String
    let errorMessage: String
}

struct ErrorDetail: Codable {
    let field: String
    let message: String
}

// MARK: - HTTP
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
