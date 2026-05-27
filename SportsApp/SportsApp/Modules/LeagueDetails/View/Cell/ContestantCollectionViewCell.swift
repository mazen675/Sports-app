//
//  ContestantCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit
import SDWebImage
class ContestantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contestantLabel: UILabel!
    @IBOutlet weak var contestantImageView: UIImageView!
    
    func config(contestant: TeamModel){
        
        contestantLabel.text = contestant.safeTeamName
        contestantImageView.sd_setImage(with: URL(string:contestant.safeTeamLogo), placeholderImage: UIImage(named: "default"))
        
        
        contestantImageView.contentMode = .scaleAspectFill
        contestantImageView.backgroundColor = .systemGray6
        contestantImageView.layer.cornerRadius = contestantImageView.frame.width / 2
        contestantImageView.clipsToBounds = true

        contestantImageView.layer.borderWidth = 2.0
        contestantImageView.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
