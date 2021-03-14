//
//  SearchViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit
import Kingfisher


class SearchViewController: UITableViewController {

    private var results: [SearchResultViewModel] = []
//    private var suggestedResults: [SearchResultViewModel] = [
//        SearchResultViewModel(title: "My Awesome podcsast", author: "Ben", imageUrl: nil),
//        SearchResultViewModel(title: "Another cool podcast", author: "Joe", imageUrl:nil)
//        
//    ]
    private var suggestedResults: [SearchResultViewModel] = [
        SearchResultViewModel(title: "My Awesome podcsast", author: "Ben", imageUrl: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/b8/6c/ff/b86cffb9-d1fe-1cd7-b363-d39a9ecbcee4/00602517170612.rgb.jpg/1000x1000bb.webp")),
        SearchResultViewModel(title: "Another cool podcast", author: "Joe", imageUrl:URL(string:  "https://is2-ssl.mzstatic.com/image/thumb/Music123/v4/ae/90/4b/ae904b69-3614-5e0f-6a84-a4e08f344f36/4050538557152.jpg/1000x1000bb.webp"))

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
