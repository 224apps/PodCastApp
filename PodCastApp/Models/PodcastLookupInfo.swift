//
//  PodcastLookupInfo.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/18/21.
//

import Foundation


struct PodcastLookupInfo {
    var id: String
    var feedURL: URL
    
    init(id: String, feedURL: URL) {
        self.id = id
        self.feedURL = feedURL
    }
}
