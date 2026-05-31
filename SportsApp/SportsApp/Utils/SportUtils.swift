//
//  SportUtils.swift
//  SportsApp
//
//  Created by Mazen Amr on 28/05/2026.
//

import Foundation
import UIKit
public func getPlaceholderImage(for sport: String) -> String {
    switch sport.lowercased() {
    case "football":
        "football_default"
    case "basketball":
        "basketball_default"
    case "cricket":
        "cricket_default"
    case "tennis":
        "tennis_default"
    default:
        "football_default"
    }
}

public func getSportColor(for sportIndex: Int) -> UIColor {
    switch sportIndex {
    case 1:
        UIColor.red
    case 2:
        UIColor.green
    case 3:
        UIColor.blue
    case 4:
        UIColor.orange
    default:
        UIColor.orange
    }
}
