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
    
   private let dataManager = PodcastDataManager()
    
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
        super.viewDidAppear(true)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func loadRecommendedpodcasts(){
        
        dataManager.recommendedPodcasts { result in
            switch result {
                case .success(let podcastResults):
                    self.recommendedPodcasts = podcastResults
                    self.results = self.recommendedPodcasts
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error Loading recommended podcasts \(error.localizedDescription)")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = results[indexPath.row]
        
        dataManager.lookupInfo(for: searchResult){ result in
            switch result {
            case .success(let lookupInfo):
                if let lookupInfo = lookupInfo {
                    self.showPodcast(with: lookupInfo)
                } else {
                    print("Podcast not found")
                }
            case .failure(let error):
                print("Error loading podcast: \(error.localizedDescription)")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    private func showPodcast(with lookupInfo: PodcastLookupInfo){
        let detailVC = UIStoryboard(name:"PodcastDetail", bundle: nil).instantiateInitialViewController() as! PodcastDetailViewController
        detailVC.lookUpInfo = lookupInfo
        show(detailVC, sender: self)
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let term = searchController.searchBar.text  ?? ""
        if term.isEmpty {
            resetToRecommendedPodcasts()
            return
        }
        dataManager.search(for: term) { (result) in
            switch result {
                case .success(let searchResults):
                    self.results = searchResults
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


