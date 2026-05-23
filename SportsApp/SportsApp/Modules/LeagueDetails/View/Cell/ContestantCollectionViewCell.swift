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
    
    func config(contestant:Contestant){
        contestantLabel.text = contestant.name
        contestantImageView.sd_setImage(with: URL(string:contestant.logoURL!), placeholderImage: UIImage(named: "Liverpool"))
        // UIImage(systemName: "star.fill"))
    }
}
