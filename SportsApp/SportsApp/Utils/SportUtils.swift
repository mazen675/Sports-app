//
//  SportUtils.swift
//  SportsApp
//
//  Created by Mazen Amr on 28/05/2026.
//

import Foundation
import UIKit
import Reachability
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

public func getCardbackGroundImage(for sport: String) -> String {
    switch sport.lowercased() {
    case "football":
        "football_card"
    case "basketball":
        "basketball_card"
    case "cricket":
        "cricket_card"
    case "tennis":
        "tennis_card"
    default:
        "football_card"
    }
}


public func hasConnectivity() -> Bool {
    let reachability = try? Reachability()
    return reachability?.connection != .unavailable
}
