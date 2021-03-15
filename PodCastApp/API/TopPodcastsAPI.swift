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
    case decodingError(DecodingError)
}

public class TopPodcastsAPI {
    private let session: URLSession
    private let baseURL: URL  = URL(string: "https://rss.itunes.apple.com/api/v1/us/podcasts/")!
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    fileprivate func parseDecodable<T: Decodable>(completion: @escaping (Result<T, APIError>) -> Void) ->  (Result<Data, APIError>) -> Void {
        
        return  { result  in
            switch result {
                case .success(let data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        let object = try jsonDecoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(object))
                        }
                    } catch(let decodingError as DecodingError) {
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError(decodingError)))
                        }
                    }catch {
                        fatalError("Unhandled error raised.")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
            }
        }
    }
    
    func fetchTopPodcasts(limit: Int = 50, allowExplicit: Bool = false, completion: @escaping (Result<Response, APIError>) ->()){
        
        let explicit = allowExplicit ? "explicit" : "non-explicit"
        let path = "top-podcasts/all/\(limit)/\(explicit).json"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest(url: url)
        perform(request, completion: parseDecodable(completion: completion))
    }
    
    fileprivate func perform(_ request: URLRequest,   completion: @escaping (Result<Data, APIError>) -> ()) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.networkingError(error)))
                return
            }
            
            guard  let http = response as? HTTPURLResponse, let data = data  else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            switch http.statusCode {
                case 200:
                    completion(.success(data))
                    
                case 400...499:
                    let body = String(data:data, encoding: .utf8)
                    completion(.failure(APIError.requestError(http.statusCode, body ?? "<no body>")))
                case 500...599:
                    completion(.failure(APIError.serverError))
                default:
                    fatalError("Unhandled HTTP status code: \(http.statusCode)")
            }
        }
        task.resume()
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
