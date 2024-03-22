//
//  APIError.swift
//  fetchAssessment
//
//  Created by Joshua Ho on 3/17/24.
//

import Foundation

// Helper enum for tracking api errors. Conforms to Error protocol to mark service functions as throwing
enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case emptyData
    case serviceUnavailable
    case decodingError

    var description: String {
        switch self {
        case .invalidUrl:
            return "invalid URL"
        case .invalidResponse:
            return "invalid response"
        case .emptyData:
            return "empty data"
        case .serviceUnavailable:
            return "service unavailable"
        case .decodingError:
            return "decoding error"
        }
    }
}
