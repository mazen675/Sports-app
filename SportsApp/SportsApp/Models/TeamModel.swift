import Foundation

struct TeamModel: Decodable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    let players: [Player]?
    
    // for tennis
    let playerKey:Int?
    let playerName:String?
    let playerLogo:String?
    
    var safeTeamName: String { return teamName ?? playerName ?? "Unknown Team" }
    var safeTeamLogo: String { return teamLogo ?? playerLogo ?? "" }
    var safeTeamKey:Int? {return teamKey ?? playerKey}
    
    var safePlayers: [Player] { return players ?? [] }
    
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
}
