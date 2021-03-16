//
//  PodcastFeedLoaderTests.swift
//  PodCastAppTests
//
//  Created by Abdoulaye Diallo on 3/15/21.
//

import XCTest
@testable import PodCastApp

class PodcastFeedLoaderTests: XCTestCase {
    
    func testCanParseFeed(){
        let feeds = [
            "http://feeds.gimletmedia.com/hearreplyall",
            "http://podcast.armadamusic.com/asot/podcast.xml",
            "http://feeds.publicradio.org/public_feeds/in-the-dark/itunes/rss"
        ].compactMap(URL.init)
        
        for feed in feeds {
            let exp = expectation(description: "Loading feed \(feed)")
            PodcastFeedLoader().fetch(feed: feed){ result  in
                exp.fulfill()
                switch result {
                    case .failure(let e):
                        XCTFail(e.localizedDescription)
                    case .success(let podcast):
                        XCTAssertNotNil(podcast.title)
                }
            }
            waitForExpectations(timeout: 10)
        }
    }
}
