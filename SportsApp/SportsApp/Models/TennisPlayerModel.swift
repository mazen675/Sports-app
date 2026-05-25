import Foundation

struct TennisPlayerModel: Decodable {
    var playerKey: String?
    let playerName: String?
    let playerCountry: String?
    let playerBday: String?
    let playerLogo: String?
    let stats: [TennisStat]?
    let tournaments: [TennisTournament]?
    
    var safeName: String { return playerName ?? "Unknown Player" }
    var safeLogo: String { return playerLogo ?? "placeholder_avatar" }
    var safeSubtitle: String {
        let country = playerCountry ?? "Unknown Country"
        let bday = playerBday ?? ""
        return bday.isEmpty ? country : "\(country) • Born: \(bday)"
    }
    
    var safeTournaments: [TennisTournament] { return tournaments ?? [] }
    var safeStats: [TennisStat] { return stats ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerCountry = "player_country"
        case playerBday = "player_bday"
        case playerLogo = "player_logo"
        case stats
        case tournaments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playerName = try container.decodeIfPresent(String.self, forKey: .playerName)
        playerCountry = try container.decodeIfPresent(String.self, forKey: .playerCountry)
        playerBday = try container.decodeIfPresent(String.self, forKey: .playerBday)
        playerLogo = try container.decodeIfPresent(String.self, forKey: .playerLogo)
        stats = try container.decodeIfPresent([TennisStat].self, forKey: .stats)
        tournaments = try container.decodeIfPresent([TennisTournament].self, forKey: .tournaments)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .playerKey) {
            playerKey = String(intKey)
        } else {
            playerKey = try container.decodeIfPresent(String.self, forKey: .playerKey)
        }
    }
}

// Nested Structs for Details
struct TennisStat: Decodable {
    let season: String?
    let type: String?
    let rank: String?
    let titles: String?
    let matches_won: String?
    let matches_lost: String?
    let hard_won: String?
    let clay_won: String?
    let grass_won: String?
    let hard_lost: String?
    let clay_lost: String?
    let grass_lost: String?
}

struct TennisTournament: Decodable {
    let name: String?
    let season: String?
    let surface: String?
    let prize: String?
    let type: String?
}
