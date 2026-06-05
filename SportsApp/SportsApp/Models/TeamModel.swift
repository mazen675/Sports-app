import Foundation

struct TeamModel: Decodable {
    var teamKey: String?
    let teamName: String?
    let teamLogo: String?
    let players: [Player]?
    
    var safeTeamName: String { return teamName ?? "Unknown Team" }
    var safeTeamLogo: String { return teamLogo ?? "" }
    var safePlayers: [Player] { return players ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerLogo = "player_logo"
        
        case players
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
                ?? (try container.decodeIfPresent(String.self, forKey: .playerName))
        
        teamLogo = try container.decodeIfPresent(String.self, forKey: .teamLogo)
                ?? (try container.decodeIfPresent(String.self, forKey: .playerLogo))
        
        players = try container.decodeIfPresent([Player].self, forKey: .players)
        
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

struct Player: Decodable {
    let playerName: String?
    let playerNumber: String?
    let playerType: String?
    let playerImage: String?
    
    var safePlayerName: String { return playerName ?? "Unknown Player" }
    var safePlayerNumber: String { return playerNumber ?? "-" }
    var safePlayerType: String { return playerType ?? "Position N/A" }
    var safePlayerImage: String { return playerImage ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerImage = "player_image"
    }
}
