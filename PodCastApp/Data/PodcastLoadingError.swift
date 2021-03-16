//
//  PodcastFeedLoadingError.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/15/21.
//

import Foundation


enum PodcastLoadingError : Error {
    case feedMissingData(String)
    case networkDecodingError(DecodingError)
    case invalidResponse
    case loadError(Error)
    case feedParsingError(Error)
    case notFound
    case requestFailed(Int)
    
    
    var localizedDescription: String {
        switch self {
        case .feedMissingData(let key): return "Feed is missing data for key: \(key)"
        case .networkDecodingError(let decodingError): return "Error decoding response: \(decodingError.localizedDescription)"
        case .feedParsingError(let error): return "Parsing Error: \(error.localizedDescription)"
        case .loadError(let error): return "Error loading feed: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid response loading feed"
        case .notFound: return "Feed not found"
        case .requestFailed(let status): return "HTTP \(status) returned fetching feed."
        }
    }

    static func convert(from error: APIError) -> PodcastLoadingError {
        switch error {
        case .decodingError(let dec): return .networkDecodingError(dec)
        case .invalidResponse: return .invalidResponse
        case .networkingError(let e): return .loadError(e)
        case .requestError(let status, _): return .requestFailed(status)
        case .serverError: return .loadError(error)
        }
    }
}
