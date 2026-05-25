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
            
        playerImageView.sd_setImage(with: URL(string: player.safeLogo), placeholderImage: UIImage(named: "Liverpool"))

        }
    
}
