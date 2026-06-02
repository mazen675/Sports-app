//
//  UpcomingEventCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit
import SDWebImage
class UpcomingEventCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeContestantLabel: UILabel!
    @IBOutlet weak var awayContestantLabel: UILabel!
    @IBOutlet weak var homeContestantImageView: UIImageView!
    @IBOutlet weak var awayContestantImageView: UIImageView!
    
    func config(event: EventModel,placeHolder:String, bgImage:String) {
        bgImageView.image = UIImage(named: bgImage)
        
        dateLabel.text = "\(event.safeDate) . \(event.safeTime)"
        homeContestantLabel.text = event.safeHomeTeam
        awayContestantLabel.text = event.safeAwayTeam
        
        let homeURL = URL(string: event.homeTeamLogo ?? "")
        homeContestantImageView.sd_setImage(with: homeURL, placeholderImage: UIImage(named: placeHolder))
        
        let awayURL = URL(string: event.awayTeamLogo ?? "")
        awayContestantImageView.sd_setImage(with: awayURL, placeholderImage: UIImage(named: placeHolder))
        
        self.layer.cornerRadius = 16
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.blue.cgColor
    
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
    }
}
