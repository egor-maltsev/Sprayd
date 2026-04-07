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
    let errorDetails: [ErrorDetail]?
    
    enum CodingKeys: String, CodingKey {
        case errorType = "error_type"
        case errorMessage = "error_message"
        case errorDetails = "error_details"
    }
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
