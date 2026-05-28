//
//  SportUtils.swift
//  SportsApp
//
//  Created by Mazen Amr on 28/05/2026.
//

import Foundation

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
