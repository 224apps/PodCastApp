//
//  UITableView+ReuseIdentifier.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit


extension UITableView {
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath)
        return cell as! T
    }
}
