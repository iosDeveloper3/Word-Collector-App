//
//  APIInteractionError.swift
//  Word Collector
//
//  Created by Dawid Herman on 28/08/2022.
//

import Foundation

enum APIInteractionError: Error {
    case unableToCreateRequest
    case noAPIResponse
    case responseDecodingError
}

extension APIInteractionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToCreateRequest:
            return NSLocalizedString("Creating request failed", comment: "Creating request failed.")
        case .noAPIResponse:
            return NSLocalizedString("No API response", comment: "No API response has been received.")
        case .responseDecodingError:
            return NSLocalizedString("Response decoding failed", comment: "Response decoding failed.")
        }
    }
}
