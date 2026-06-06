import Foundation

struct LeagueModel: Decodable {
    let leagueKey: Int?
    let leagueName: String?
    var leagueLogo: String?
    var countryName: String?
    var leagueYear: String?
    
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

}
