//
//  NetworkAPIError.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import Foundation

/// Customized error used on CoreNetwork framework to property handler the errors.
enum NetworkAPIError: Error, Equatable {
    public static func == (lhs: NetworkAPIError, rhs: NetworkAPIError) -> Bool {
        return lhs.customDescription == rhs.customDescription
    }
    
    case invalidUrl
    case unauthorized
    case invalidResponse
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    case unkownGenericError(description: String)
    
    /// Custom description for each error type
    var customDescription: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case .unauthorized: return "Unauthorized user"
        case .invalidResponse: return "Invalid Response"
        case .invalidData: return "Invalid data"
        case .jsonParsingFailure: return"Failed to parse JSON"
        case let .requestFailed(description): return "Request failed: \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code: \(statusCode)"
        case let .unknownError(error): return "An unknown error occured: \(error.localizedDescription)"
        case let .unkownGenericError(description): return "An generic unknown error occurred: \(description)"
        }
    }
}
