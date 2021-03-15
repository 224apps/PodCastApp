//
//  SearchViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit
import Kingfisher


class SearchViewController: UITableViewController {
    
    private var results: [SearchResult] = []
    private var recommendedPodcasts: [SearchResult] = []
    
    private let podcastClient = TopPodcastsAPI()
    private let searchClient = PodcastSearchAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Theme.Colors.gray4
        tableView.separatorColor =  Theme.Colors.gray3
        tableView.separatorInset = .zero
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        loadRecommendedpodcasts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func loadRecommendedpodcasts(){
        podcastClient.fetchTopPodcasts(limit: 50, allowExplicit: false) { (result) in
            switch result {
                case .success(let response):
                    self.recommendedPodcasts =  response.feed.results.map(SearchResult.init)
                    self.results = self.recommendedPodcasts
                    self.tableView.reloadData()
                    
                case.failure(let error):
                    print("Error loading recommended podcasts: \(error.localizedDescription)")
                    
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeue(for: indexPath)
        let searchResult = results[indexPath.row]
        cell.configure(with: searchResult)
        return cell
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let term = searchController.searchBar.text  ?? ""
        if term.isEmpty {
            resetToRecommendedPodcasts()
            return
        }
        searchClient.search(for: term) { (result) in
            switch result {
                case .success(let response):
                    self.results = response.results.map(SearchResult.init)
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error searching podcasts: \(error.localizedDescription)")
            }
        }
    }
    
    private func resetToRecommendedPodcasts(){
        results = recommendedPodcasts
        tableView.reloadData()
    }
}


