//
//  PodcastDetailHeaderViewController.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/16/21.
//

import UIKit
import Kingfisher

class PodcastDetailHeaderViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var suscribeLabel: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var podcast: Podcast!{
        didSet{
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    private func updateUI(){
        let options: KingfisherOptionsInfo = [.transition(.fade(1.0))]
        imageView.kf.setImage(with: podcast.artworkURL, placeholder: nil, options: options)
        
        titleLabel.text = podcast.title
        authorLabel.text = podcast.author
        genreLabel.text = podcast.primaryGenre
        descriptionLabel.text = podcast.description
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
