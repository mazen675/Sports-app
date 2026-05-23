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
    
    
    func config(fixture:Fixture){
        dateLabel.text = fixture.date
        homeContestantLabel.text = fixture.homeContestant.name
        awayContestantLabel.text = fixture.awayContestant.name
        homeContestantImageView.sd_setImage(with: URL(string: fixture.homeContestant.logoURL!), placeholderImage: UIImage(systemName: "star.fill"))
        
        awayContestantImageView.sd_setImage(with: URL(string: fixture.awayContestant.logoURL!), placeholderImage: UIImage(systemName: "star.fill"))
        scoreLabel.text = fixture.score
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
}
