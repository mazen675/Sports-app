import Foundation

struct TeamModel: Decodable {
    var teamKey: String?
    let teamName: String?
    let teamLogo: String?
    let coaches: [Coach]?
    let players: [Player]?
    
    var safeTeamName: String { return teamName ?? "Unknown Team" }
    var safeTeamLogo: String { return teamLogo ?? "placeholder_logo" }
    var safeCoaches: [Coach] { return coaches ?? [] }
    var safePlayers: [Player] { return players ?? [] }
    
    enum CodingKeys: String, CodingKey {
        // Football / Team Sports
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        
        // Tennis / Individual Sports
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerLogo = "player_logo"
        
        // Shared
        case coaches
        case players
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try team name first, if nil, try player name
        teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
                ?? (try container.decodeIfPresent(String.self, forKey: .playerName))
        
        // Try team logo first, if nil, try player logo
        teamLogo = try container.decodeIfPresent(String.self, forKey: .teamLogo)
                ?? (try container.decodeIfPresent(String.self, forKey: .playerLogo))
        
        coaches = try container.decodeIfPresent([Coach].self, forKey: .coaches)
        players = try container.decodeIfPresent([Player].self, forKey: .players)
        
        // Handle Key (Int to String conversion for both scenarios)
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .teamKey) {
            teamKey = String(intKey)
        } else if let intPlayerKey = try? container.decodeIfPresent(Int.self, forKey: .playerKey) {
            teamKey = String(intPlayerKey)
        } else {
            teamKey = try container.decodeIfPresent(String.self, forKey: .teamKey)
                   ?? (try container.decodeIfPresent(String.self, forKey: .playerKey))
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
