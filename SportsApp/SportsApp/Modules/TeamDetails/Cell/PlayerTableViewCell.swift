//
//  PlayerTableViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {


    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Make the image circular if desired
            playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
            playerImageView.clipsToBounds = true
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    


        // Add this config function
        func config(player: Player2) {
            playerNameLabel.text = player.name
            playerInfoLabel.text = player.position
            
            // Optional: Set a dummy image for testing
            playerImageView.image = UIImage(systemName: "person.circle.fill")
            playerImageView.tintColor = .systemGray
        }
}
