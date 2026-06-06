import Foundation

struct TennisPlayerModel: Decodable {
    var playerKey: Int?
    let playerName: String?
    let playerCountry: String?
    let playerBday: String?
    let playerLogo: String?
    let stats: [TennisStat]?
    let tournaments: [TennisTournament]?
    
    var safeName: String { return playerName ?? "Unknown Player" }
    var safeLogo: String { return playerLogo ?? "" }
    
    var safeTournaments: [TennisTournament] { return tournaments ?? [] }
    var safeStats: [TennisStat] { return stats ?? [] }
    
   
}

struct TennisStat: Decodable {
    let season: String?
    let type: String?
    let rank: String?
    let titles: String?
    let matchesWon: String?
    let matchesLost: String?
    let hardWon: String?
    let clayWon: String?
    let grassWon: String?
    let hardLost: String?
    let clayLost: String?
    let grassLost: String?
}

struct TennisTournament: Decodable {
    let name: String?
    let season: String?
    let surface: String?
    let prize: String?
    let type: String?
}
