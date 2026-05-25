//
//  PlayerTableViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit
import SDWebImage // Required to load the real player images!

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Make the image perfectly circular
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        playerImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 🚨 THE FIX: Using the real 'Player' struct from your TeamModel.swift
    func config(player: Player) {
        
        // 1. Real Name
        playerNameLabel.text = player.safePlayerName
        
        // 2. Real Number and Position
        playerInfoLabel.text = "No. \(player.safePlayerNumber) • \(player.safePlayerType)"
        
        // 3. Live Image Loading
        if let url = URL(string: player.safePlayerImage) {
            playerImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle.fill"))
        } else {
            playerImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        playerImageView.tintColor = .systemGray
    }
}
