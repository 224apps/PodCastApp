//
//  TopPodcastsAPI.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/14/21.
//

import UIKit

enum APIError: Error{
    case networkingError(Error)
    case serverError
    case requestError(Int, String)
    case invalidResponse
}

public class TopPodcastsAPI {
    private let session: URLSession
    private let baseURL: URL  = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/")!
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    fileprivate func performRequest(_ request: URLRequest, _ completion: @escaping (Result<Data, Error>) -> ()) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(APIError.networkingError(error)))
                }
                return
            }
            
            guard  let http = response as? HTTPURLResponse, let data = data  else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }
            
            switch http.statusCode {
                case 200:
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case 400...499:
                    let body = String(data:data, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(.failure(APIError.requestError(http.statusCode, body ?? "<no body>")))
                    }
                case 500...599:
                    DispatchQueue.main.async {
                        completion(.failure(APIError.serverError))
                    }
                default:
                    fatalError("Unhandled HTTP status code: \(http.statusCode)")
            }
        }
        task.resume()
    }
    
    
    func fetchTopPodcasts(limit: Int = 50, allowExplicit: Bool = false, completion: @escaping (Result<Data, Error>) ->()){
        
        let explicit = allowExplicit ? "explicit" : "non-explicit"
        let path = "top-podcasts/all/\(limit)/\(explicit).json"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest(url: url)
        
        performRequest(request, completion)
    }
}
