//
//  PodcastDetailViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit

class PodcastDetailViewController: UITableViewController {
    var feedURL: URL! = URL(string: "http://feeds.gimletmedia.com/hearreplyall")!
    
    var podcast: Podcast! {
        didSet {
            headerViewController.podcast = podcast
        }
    }
    
    var headerViewController: PodcastDetailHeaderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewController = children.compactMap{ $0 as? PodcastDetailHeaderViewController }.first
        
        
        PodcastFeedLoader().fetch(feed: feedURL) { (result) in
            switch result {
                case .success(let podcast):
                    self.podcast = podcast
                    
                case .failure(let error):
                    print("Error: - \(error)")
            }
        }
    }
}
