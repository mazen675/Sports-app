import Foundation

struct LeagueModel: Decodable {
    var leagueKey: String?
    let leagueName: String?
    let leagueLogo: String?
    var countryName: String? // Added for the cell subtitle!
    
    // Safe UI Properties
    var safeLeagueName: String { return leagueName ?? "Unknown League" }
    var safeLeagueLogo: String { return leagueLogo ?? "placeholder_logo" }
    var safeCountryName: String { return countryName ?? "Unknown Country" }
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case countryName = "country_name"
    }
    
    // 🚨 THE FIX: A standard initializer for testing and CoreData!
    init(leagueKey: String? = nil, leagueName: String? = nil, leagueLogo: String? = nil, countryName: String? = nil) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.leagueLogo = leagueLogo
        self.countryName = countryName
    }
    
    // Bulletproof Decoder for API Type Mismatches
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        leagueName = try container.decodeIfPresent(String.self, forKey: .leagueName)
        leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .leagueKey) {
            leagueKey = String(intKey)
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .leagueKey) {
            leagueKey = stringKey
        } else {
            leagueKey = nil
        }
    }
}
