//
//  StatisticsCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    //part1
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    //part2
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titlesLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    //part3
    @IBOutlet weak var hardWonLabel: UILabel!
    @IBOutlet weak var clayWonLabel: UILabel!
    @IBOutlet weak var grassWonLabel: UILabel!
    
    @IBOutlet weak var hardLostLabel: UILabel!
    @IBOutlet weak var clayLostLabel: UILabel!
    @IBOutlet weak var grassLostLabel: UILabel!
   
    func config(with stat: TennisStat) {
        seasonLabel.text = "Season " + (stat.season ?? "-")
        typeLabel.text = stat.type?.capitalized ?? "-"
        
        rankLabel.text = "#\(stat.rank ?? "-")"
        titlesLabel.text = stat.titles ?? "0"
        wonLabel.text = stat.matchesWon ?? "0"
        lostLabel.text = stat.matchesLost ?? "0"
        
        hardWonLabel.text = stat.hardWon?.isEmpty == false ? stat.hardWon : "-"
        clayWonLabel.text = stat.clayWon?.isEmpty == false ? stat.clayWon : "-"
        grassWonLabel.text = stat.grassWon?.isEmpty == false ? stat.grassWon : "-"
        
        hardLostLabel.text = stat.hardLost?.isEmpty == false ? stat.hardLost : "-"
        clayLostLabel.text = stat.clayLost?.isEmpty == false ? stat.clayLost : "-"
        grassLostLabel.text = stat.grassLost?.isEmpty == false ? stat.grassLost : "-"
    //
    //        self.layer.borderWidth = 2.0
    //        self.layer.borderColor = UIColor(named: "titles")?.cgColor
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
}
