//
//  NetworkingError.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/18/24.
//

import Foundation

enum NetworkingError: Error {
    case invalidResponse
    case httpError(statucCode: Int)
    case requestTimeout
    case noInternetConnection
    case serverError(statucCode: Int)
    case parsingError
    case unknown
}

extension NetworkingError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .requestTimeout:
            return "Request timeout"
        case .noInternetConnection:
            return "No internet connection"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .parsingError:
            return "Parsing error"
        case .unknown:
            return "Unknown error"
        }
    }
}
