//
//  EpisodeCellViewModel.swift
//  PodCastApp
//
//  Created by Abdoulaye Diallo on 3/18/21.
//

import UIKit

struct EpisodeCellViewModel {
    private let episode: Episode
    
    private static  var dataFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle  = .short
        return df
    }()
    
    private static  var timeFormatter: DateComponentsFormatter = {
        let tf = DateComponentsFormatter()
        tf.unitsStyle  = .short
        tf.allowedUnits = [.hour, .minute, .second]
        return tf
    }()
    
    init(episode:Episode){
        self.episode = episode
    }
    
    var title: String {
        return episode.title ?? "<untitled>"
    }
    
    var description: String? {
        return episode.description
    }
    
    var info: String {
        let parts = [timeString, dataString].compactMap { $0}
        return parts.joined(separator: " • ")
    }
    
    private var timeString: String? {
        guard let duration = episode.duration else { return nil}
        return EpisodeCellViewModel.timeFormatter.string(from: duration)
    }
    
    private var dataString: String? {
        guard let publicationDate = episode.publicationDate else { return nil}
        return EpisodeCellViewModel.dataFormatter.string(from: publicationDate)
    }
    
}
