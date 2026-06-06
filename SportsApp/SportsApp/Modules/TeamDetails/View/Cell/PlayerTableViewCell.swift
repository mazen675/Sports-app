//
//  PlayerTableViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit
import SDWebImage
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

    func config(player: Player) {
        
        playerNameLabel.text = player.safePlayerName
        
        playerInfoLabel.text = "No. \(player.safePlayerNumber) • \(player.safePlayerType)"
        
        if let url = URL(string: player.safePlayerImage) {
            playerImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle.fill"))
        } else {
            playerImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        playerImageView.tintColor = .systemGray
    }
}
