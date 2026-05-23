//
//  TeamModel.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

struct TeamModel: Decodable {
    var teamKey: String?
    let teamName: String?
    let teamLogo: String?
    let coaches: [Coach]?
    let players: [Player]?
    
    // Safe UI Properties
    var safeTeamName: String { return teamName ?? "Unknown Team" }
    var safeTeamLogo: String { return teamLogo ?? "placeholder_logo" }
    var safeCoaches: [Coach] { return coaches ?? [] }
    var safePlayers: [Player] { return players ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case coaches
        case players
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
        teamLogo = try container.decodeIfPresent(String.self, forKey: .teamLogo)
        coaches = try container.decodeIfPresent([Coach].self, forKey: .coaches)
        players = try container.decodeIfPresent([Player].self, forKey: .players)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .teamKey) {
            teamKey = String(intKey)
        } else {
            teamKey = try container.decodeIfPresent(String.self, forKey: .teamKey)
        }
    }
}

// Nested Structs for Team Details
struct Coach: Decodable {
    let coachName: String?
    var safeCoachName: String { return coachName ?? "Unknown Coach" }
    enum CodingKeys: String, CodingKey { case coachName = "coach_name" }
}

struct Player: Decodable {
    let playerName: String?
    let playerNumber: String?
    let playerType: String?
    let playerImage: String?
    
    var safePlayerName: String { return playerName ?? "Unknown Player" }
    var safePlayerNumber: String { return playerNumber ?? "-" }
    var safePlayerType: String { return playerType ?? "Position N/A" }
    var safePlayerImage: String { return playerImage ?? "placeholder_avatar" }
    
    enum CodingKeys: String, CodingKey {
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerImage = "player_image"
    }
}