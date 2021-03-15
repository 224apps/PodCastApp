//
//  PodcastSearchAPI.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/15/21.
//

import UIKit


class PodcastSearchAPI: APIClient {
    let session: URLSession
    private let baseURL = URL(string: "https://itunes.apple.com")!
    private var activeSearchTask: URLSessionDataTask?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func search(for term: String, country: String = "us", completion: @escaping (Result<Response, APIError>) -> Void) {
        
        let url = baseURL.appendingPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "country", value: country),
                                 URLQueryItem(name: "media", value: "podcast"),
                                 URLQueryItem(name: "entity", value: "podcast"),
                                 URLQueryItem(name: "attribute", value: "titleTerm"),
                                 URLQueryItem(name: "term", value: term)]
        let request = URLRequest(url: components.url!)
        
        activeSearchTask?.cancel()
        activeSearchTask = perform(request: request, completion: parseDecodable(completion: completion))
    }
}


extension PodcastSearchAPI {
    
    struct Response:Decodable {
        let resultCount: Int
        let results: [PodcastSearchResult]
    }
    
    struct PodcastSearchResult: Decodable {
        let artistName: String
        let collectionName: String
        let artworkUrl100: String
        let genreIds: [String]
        let genres: [String]
    }
}
