//
//  Podcast.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/15/21.
//

import Foundation


class Podcast{
    var id: String
    var feedURL: URL
    var title: String?
    var author: String?
    var description: String?
    var primaryGenre: String?
    var artworkURL: URL?
    var episodes: [Episode] = []
    
    init(id: String, feedURL: URL) {
        self.id = id
        self.feedURL = feedURL
    }
}
