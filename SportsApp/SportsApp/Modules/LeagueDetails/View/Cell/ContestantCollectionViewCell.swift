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
        contestantImageView.sd_setImage(with: URL(string:contestant.safeTeamLogo), placeholderImage: UIImage(named: "liverpool"))
        // UIImage(systemName: "star.fill"))
    }
}
