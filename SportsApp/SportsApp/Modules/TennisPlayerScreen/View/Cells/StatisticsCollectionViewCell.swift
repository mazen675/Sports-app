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
        wonLabel.text = stat.matches_won ?? "0"
        lostLabel.text = stat.matches_lost ?? "0"
        
        hardWonLabel.text = stat.hard_won?.isEmpty == false ? stat.hard_won : "-"
        clayWonLabel.text = stat.clay_won?.isEmpty == false ? stat.clay_won : "-"
        grassWonLabel.text = stat.grass_won?.isEmpty == false ? stat.grass_won : "-"
        
        hardLostLabel.text = stat.hard_lost?.isEmpty == false ? stat.hard_lost : "-"
        clayLostLabel.text = stat.clay_lost?.isEmpty == false ? stat.clay_lost : "-"
        grassLostLabel.text = stat.grass_lost?.isEmpty == false ? stat.grass_lost : "-"
//        
//        self.layer.borderWidth = 2.0
//        self.layer.borderColor = UIColor(named: "titles")?.cgColor
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
}
