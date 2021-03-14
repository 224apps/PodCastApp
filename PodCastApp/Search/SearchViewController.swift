//
//  SearchViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit

class SearchViewController: UITableViewController {

    private var results: [SearchResultViewModel] = []
    private var suggestedResults: [SearchResultViewModel] = [
        SearchResultViewModel(title: "My Awesome re", author: "Ben", imageUrl: nil),
        SearchResultViewModel(title: "Another cool podcast", author: "Joe", imageUrl: nil)
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results = suggestedResults
        
        tableView.backgroundColor = Theme.Colors.gray4
        tableView.separatorColor =  Theme.Colors.gray3
        tableView.separatorInset = .zero
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeue(for: indexPath)
        let result = results[indexPath.row]
        cell.configure(with: result)
        return cell
    }
}
