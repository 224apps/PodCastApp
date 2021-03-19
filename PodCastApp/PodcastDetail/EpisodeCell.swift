//
//  EpisodeCell.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/17/21.
//

import UIKit


class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = Theme.Colors.gray5
        titleLabel.textColor = Theme.Colors.gray0
        infoLabel.textColor = Theme.Colors.gray2
        descriptionLabel.textColor = Theme.Colors.gray2
    }
    
    func configure(with viewModel: EpisodeCellViewModel){
        titleLabel.text = viewModel.title
        infoLabel.text = viewModel.info
        descriptionLabel.text = viewModel.description
    }
}
