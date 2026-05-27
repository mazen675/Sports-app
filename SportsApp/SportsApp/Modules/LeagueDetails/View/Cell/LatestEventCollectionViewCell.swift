//
//  LatestEventCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit
import SDWebImage
class LatestEventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeContestantLabel: UILabel!
    @IBOutlet weak var awayContestantLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeContestantImageView: UIImageView!
    @IBOutlet weak var awayContestantImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    func config(event: EventModel) {
            dateLabel.text = event.safeDate
            homeContestantLabel.text = event.safeHomeTeam
            awayContestantLabel.text = event.safeAwayTeam
            scoreLabel.text = event.safeScore
            
            let homeURL = URL(string: event.homeTeamLogo ?? "")
            homeContestantImageView.sd_setImage(with: homeURL, placeholderImage: UIImage(systemName: "star.fill"))
            
            let awayURL = URL(string: event.awayTeamLogo ?? "")
            awayContestantImageView.sd_setImage(with: awayURL, placeholderImage: UIImage(systemName: "star.fill"))
            
            self.layer.cornerRadius = 16
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.blue.cgColor

            bgImageView.contentMode = .scaleAspectFill
            bgImageView.clipsToBounds = true
        }
    
}
