//
//  CustomTableViewHeader.swift
//  SportsApp
//
//  Created by Mazen Amr on 27/05/2026.
//

import UIKit

class CustomTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var coloredLineView: UIView!
    
    @IBOutlet weak var SectionHeaderLabel: UILabel!
    
    func config(color:UIColor,title:String ){
        coloredLineView.backgroundColor = color
        SectionHeaderLabel.text = title
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
