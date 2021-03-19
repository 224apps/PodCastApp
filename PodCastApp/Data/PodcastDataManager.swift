//
//  PodcastDataManager.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import Foundation


class PodcastDataManager {
    private let topPodcastsAPI = TopPodcastsAPI()
    private let searchAPI = PodcastSearchAPI()
    
    func recommendedPodcasts(completion: @escaping (Result<[SearchResult], PodcastLoadingError>)-> Void) {
        topPodcastsAPI.fetchTopPodcasts(limit: 50, allowExplicit: false) { (result) in
            switch result {
                case .success(let response):
                    let searchResults =  response.feed.results.map(SearchResult.init)
                    completion(.success(searchResults))
                case.failure(let error):
                    completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }
    
    func search(for term: String, completion: @escaping (Result<[SearchResult], PodcastLoadingError>)-> Void) {
        searchAPI.search(for: term) { (result) in
            switch result {
                case .success(let response):
                    let searchResults =  response.results.map(SearchResult.init)
                    completion(.success(searchResults))
                case.failure(let error):
                    completion(.failure(PodcastLoadingError.convert(from: error)))
            }
        }
    }
    
    func lookup(podcastID: String, completion: @escaping (Result<SearchResult?, APIError>) -> Void ){
        searchAPI.lookup(id: podcastID) { (result) in
            completion(result)
        }
    }
    
    func lookupInfo(for searchResult: SearchResult, completion: @escaping (Result<PodcastLookupInfo?, APIError>)-> Void){
        if let feed = searchResult.feedURL {
            let lookup = PodcastLookupInfo(id: searchResult.id, feedURL: feed)
            completion(.success(lookup))
        }else{
            searchAPI.lookup(id: searchResult.id) { (result) in
                switch result {
                    case .success(let updatedResult):
                        let lookupInfo = updatedResult?.feedURL.flatMap{PodcastLookupInfo(id: searchResult.id, feedURL: $0)}
                        completion(.success(lookupInfo))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
}
