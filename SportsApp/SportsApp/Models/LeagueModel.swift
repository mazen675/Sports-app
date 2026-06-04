import Foundation

struct LeagueModel: Decodable {
    var leagueKey: String?
    let leagueName: String?
    let leagueLogo: String?
    var countryName: String?
    let leagueYear: String?
    
    var safeLeagueName: String { return leagueName ?? "Unknown League" }
    var safeLeagueLogo: String { return leagueLogo ?? "" }
    
    var safeCountryName: String {
        if let country = countryName, !country.isEmpty {
            return country
        } else if let year = leagueYear, !year.isEmpty {
            return "Season: \(year)"
        } else {
            return "Unknown"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case countryName = "country_name"
        case leagueYear = "league_year"
    }
    
    init(leagueKey: String? = nil, leagueName: String? = nil, leagueLogo: String? = nil, countryName: String? = nil, leagueYear: String? = nil) {
        self.leagueKey = leagueKey
        self.leagueName = leagueName
        self.leagueLogo = leagueLogo
        self.countryName = countryName
        self.leagueYear = leagueYear
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        leagueName = try container.decodeIfPresent(String.self, forKey: .leagueName)
        leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        leagueYear = try container.decodeIfPresent(String.self, forKey: .leagueYear)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .leagueKey) {
            leagueKey = String(intKey)
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .leagueKey) {
            leagueKey = stringKey
        } else {
            leagueKey = nil
        }
    }
}
