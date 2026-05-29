//
//  HeaderCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var bDayLabel: UILabel!
    
    func config(with player: TennisPlayerModel) {
            nameLabel.text = player.safeName
            countryLabel.text = player.playerCountry ?? "Unknown"
            bDayLabel.text = player.playerBday ?? "-"
        
            playerImageView.layer.borderWidth = 2.0
            playerImageView.layer.borderColor = UIColor(named: "titles")?.cgColor
            playerImageView.sd_setImage(with: URL(string: player.safeLogo), placeholderImage: UIImage(named: "tennis_default"))
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor(named: "titles")?.cgColor
            self.layer.cornerRadius = 16
            self.layer.masksToBounds = true
        }
    
}
