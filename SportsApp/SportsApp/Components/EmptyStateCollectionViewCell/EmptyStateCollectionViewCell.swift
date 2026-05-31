//
//  EmptyStateCollectionViewCell.swift
//  SportsApp
//
//  Created by Mazen Amr on 31/05/2026.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(title: String, subtitle: String) {
            titleLabel.text = title
            subtitleLabel.text = subtitle
        }
}
