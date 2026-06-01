//
//  TournamentCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import UIKit

class TournamentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var surfaceLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    
    func config(with tournament: TennisTournament) {
            nameLabel.text = tournament.name ?? "Unknown"
            seasonLabel.text = tournament.season ?? "-"
            typeLabel.text = tournament.type?.capitalized ?? "-"
            surfaceLabel.text = tournament.surface?.capitalized ?? "-"
            prizeLabel.text = tournament.prize ?? "-"
//            
//            self.layer.borderWidth = 2.0
//            self.layer.borderColor = UIColor(named: "titles")?.cgColor
            self.layer.cornerRadius = 16
            self.layer.masksToBounds = true
        }
    
}
