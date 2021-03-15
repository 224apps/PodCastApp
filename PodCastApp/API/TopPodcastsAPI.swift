//
//  TopPodcastsAPI.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/14/21.
//

import UIKit


public class TopPodcastsAPI: APIClient {
    var session: URLSession
    private let baseURL: URL  = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/")!
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchTopPodcasts(limit: Int = 50, allowExplicit: Bool = false, completion: @escaping (Result<Response, APIError>) ->()){
        
        let explicit = allowExplicit ? "explicit" : "non-explicit"
        let path = "top-podcasts/all/\(limit)/\(explicit).json"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest(url: url)
        perform(request: request, completion: parseDecodable(completion: completion))
    }
}

extension TopPodcastsAPI {
    
    struct Response: Decodable {
        let feed: Feed
    }
    
    struct Feed: Decodable {
        let results: [PodcastResult]
    }
    
    struct PodcastResult: Decodable {
        let id: String
        let artistName: String
        let name: String
        let artworkUrl100: String
        let genres: [Genre]
    }
    
    struct Genre:  Decodable{
        let name: String
        let genreId: String
    }
}
