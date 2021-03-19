//
//  SearchResult.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/14/21.
//

import UIKit


struct SearchResult {
    
    var id: String
    let artworkUrl: URL?
    let title : String
    let author: String
    var feedURL: URL?
    
    init(id: String, artworkUrl: URL?, title: String, author: String, feedURL: URL? ){
        self.id = id
        self.artworkUrl = artworkUrl
        self.title = title
        self.author = author
        self.feedURL = feedURL
    }
}

extension SearchResult {
    init(podcastResult: TopPodcastsAPI.PodcastResult) {
        self.init(
            id: podcastResult.id,
            artworkUrl: URL(string: podcastResult.artworkUrl100),
            title: podcastResult.name,
            author: podcastResult.artistName,
            feedURL: nil
        )
    }
}

extension SearchResult {
    init(searchResult: PodcastSearchAPI.PodcastSearchResult) {
        self.init(
            id: String(searchResult.collectionId),
            artworkUrl: URL(string: searchResult.artworkUrl100),
            title: searchResult.collectionName,
            author: searchResult.artistName, feedURL: URL(string: searchResult.artworkUrl100)
        )
    }
}
