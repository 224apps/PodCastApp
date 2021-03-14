//
//  SearchResultCell.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcstAuthorLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = Theme.Colors.gray4
        backgroundColor = Theme.Colors.gray4
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colors.gray3
        
        podcastTitleLabel.textColor = Theme.Colors.gray0
        podcstAuthorLabel.textColor = Theme.Colors.gray1
    }

    func configure(with searchResult: SearchResultViewModel){
        podcastTitleLabel.text = searchResult.title
        podcstAuthorLabel.text = searchResult.author
    }
    
}
