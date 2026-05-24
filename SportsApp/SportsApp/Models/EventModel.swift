import Foundation

struct EventModel: Decodable {
    var eventKey: String?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let homeTeamLogo: String?
    let eventAwayTeam: String?
    let awayTeamLogo: String?
    let eventFinalResult: String?
    
    var safeHomeTeam: String { return eventHomeTeam ?? "TBD" }
    var safeAwayTeam: String { return eventAwayTeam ?? "TBD" }
    var safeHomeLogo: String { return homeTeamLogo ?? "placeholder_logo" }
    var safeAwayLogo: String { return awayTeamLogo ?? "placeholder_logo" }
    var safeScore: String { return eventFinalResult ?? "vs" }
    var safeDate: String { return eventDate ?? "Date TBD" }
    var safeTime: String { return eventTime ?? "Time TBD" }
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamLogo = "home_team_logo"
        case eventAwayTeam = "event_away_team"
        case awayTeamLogo = "away_team_logo"
        case eventFinalResult = "event_final_result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventDate = try container.decodeIfPresent(String.self, forKey: .eventDate)
        eventTime = try container.decodeIfPresent(String.self, forKey: .eventTime)
        eventHomeTeam = try container.decodeIfPresent(String.self, forKey: .eventHomeTeam)
        homeTeamLogo = try container.decodeIfPresent(String.self, forKey: .homeTeamLogo)
        eventAwayTeam = try container.decodeIfPresent(String.self, forKey: .eventAwayTeam)
        awayTeamLogo = try container.decodeIfPresent(String.self, forKey: .awayTeamLogo)
        eventFinalResult = try container.decodeIfPresent(String.self, forKey: .eventFinalResult)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .eventKey) {
            eventKey = String(intKey)
        } else {
            eventKey = try container.decodeIfPresent(String.self, forKey: .eventKey)
        }
    }
}
