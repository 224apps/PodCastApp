//
//  PodCastAppTests.swift
//  PodCastAppTests
//
//  Created by Abdoulaye Diallo on 3/14/21.
//

import XCTest
@testable import PodCastApp

class TopPodcastAPITests: XCTestCase {
    var client: TopPodcastsAPI!

    override func setUp() {
        client = TopPodcastsAPI()
    }
    
    func testFetchesData(){
        let exp = expectation(description: "API Result Received")
        
        client.fetchTopPodcasts { (result) in
            exp.fulfill()
            
            switch result {
                case .success(let data):
                    XCTAssert(data.count > 0)
                    let body = String(data:data, encoding: .utf8)!
                    print(body)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        }
        wait(for: [exp], timeout: 3.0)
    }
    
}
