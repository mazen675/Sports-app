//
//  EmptyStateView.swift
//  SportsApp
//
//  Created by Mazen Amr on 31/05/2026.
//

import UIKit

class EmptyStateView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
 
    func config(title:String , subtitle:String){
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}
