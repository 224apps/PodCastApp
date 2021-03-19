//
//  PodcastDetailViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit

class PodcastDetailViewController: UITableViewController {
    
    var lookUpInfo: PodcastLookupInfo!
    
    var podcast: Podcast? {
        didSet {
            headerViewController.podcast = podcast
            tableView.reloadData()
        }
    }
    
    var headerViewController: PodcastDetailHeaderViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewController = children.compactMap{ $0 as? PodcastDetailHeaderViewController }.first
        loadPodcast(lookupInfo: lookUpInfo)
    }
    
    private func loadPodcast(lookupInfo: PodcastLookupInfo) {
        PodcastFeedLoader().fetch(lookupInfo: lookupInfo) { (result) in
            switch result {
                case .success(let podcast):
                    self.podcast = podcast
                case .failure(let error):
                    self.headerViewController.clearUI()
                    let alert  = UIAlertController(title: "Failed to Load Podcast",
                                                   message: "Error loading feed \(error.localizedDescription)",
                                                   preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                        self.loadPodcast(lookupInfo: lookupInfo)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast?.episodes.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCell = tableView.dequeue(for: indexPath)
        
        if let episode = podcast?.episodes[indexPath.row]{
        let viewModel = EpisodeCellViewModel(episode: episode)
        cell.configure(with: viewModel)
        }
        return cell
    }
    
    //MARK: - Scrolling
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustParallax(scrollView)
    }

    private func adjustParallax(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let headerView = headerViewController.view
        
        if offsetY < 0 {
            headerView?.superview?.clipsToBounds = false
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY / 10)
            headerView?.alpha = 1
        }else {
            headerView?.superview?.clipsToBounds = false
            headerView?.transform = CGAffineTransform(translationX: 0, y: offsetY / 3)
            headerView?.alpha =   1 - (offsetY / headerView!.frame.height * 0.90)
        }
    }
}
