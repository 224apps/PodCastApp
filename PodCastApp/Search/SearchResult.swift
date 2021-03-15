//
//  SearchResult.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/14/21.
//

import UIKit


struct SearchResult {
    
    let artworkUrl: URL?
    let title : String
    let author: String
    
    init(artworkUrl: URL?, title: String, author: String ){
        self.artworkUrl = artworkUrl
        self.title = title
        self.author = author
    }
}

extension SearchResult {
    init(podcastResult: TopPodcastsAPI.PodcastResult) {
        self.init(artworkUrl: URL(string: podcastResult.artworkUrl100), title: podcastResult.name, author: podcastResult.artistName)
    }
}

extension SearchResult {
    init(searchResult: PodcastSearchAPI.PodcastSearchResult) {
        self.init(artworkUrl: URL(string: searchResult.artworkUrl100), title: searchResult.collectionName, author: searchResult.artistName)
    }
}
