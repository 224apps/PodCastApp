//
//  SearchResultCell.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/13/21.
//

import UIKit
import Kingfisher

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcstAuthorLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        artworkImageView.backgroundColor = Theme.Colors.gray3
        artworkImageView.layer.cornerRadius = 10.0
        artworkImageView.layer.masksToBounds = true
        
        
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = Theme.Colors.gray4
        backgroundColor = Theme.Colors.gray4
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Theme.Colors.gray3
        
        podcastTitleLabel.textColor = Theme.Colors.gray0
        podcstAuthorLabel.textColor = Theme.Colors.gray1
    }

    func configure(with result: SearchResultViewModel){
        
        podcastTitleLabel.text = result.title
        podcstAuthorLabel.text = result.author
        
        if let url = result.imageUrl {
            let options: KingfisherOptionsInfo = [
                .transition(.fade(0.5))
            ]
            artworkImageView.kf.setImage(with: url,options: options)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        podcastTitleLabel.textColor = nil
        podcstAuthorLabel.textColor = nil
        
        artworkImageView.kf.cancelDownloadTask()
        artworkImageView.image = nil
    }
    
}
