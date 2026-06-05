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
    let eventStatus: String?
    var safeEventStatus: String { return eventStatus ?? "" }
    var safeHomeTeam: String { return eventHomeTeam ?? "TBD" }
    var safeAwayTeam: String { return eventAwayTeam ?? "TBD" }
    var safeScore: String { return eventFinalResult ?? "vs" }
    var safeDate: String { return eventDate ?? "Date TBD" }
    var safeTime: String { return eventTime ?? "Time TBD" }
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventFinalResult = "event_final_result"
        case eventStatus = "event_status"

        case eventHomeTeam = "event_home_team"
        case homeTeamLogo = "home_team_logo"
        case eventAwayTeam = "event_away_team"
        case awayTeamLogo = "away_team_logo"
        
        case eventFirstPlayer = "event_first_player"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayer = "event_second_player"
        case eventSecondPlayerLogo = "event_second_player_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        eventDate = try container.decodeIfPresent(String.self, forKey: .eventDate)
        eventTime = try container.decodeIfPresent(String.self, forKey: .eventTime)
        eventFinalResult = try container.decodeIfPresent(String.self, forKey: .eventFinalResult)
        eventStatus = try container.decodeIfPresent(String.self, forKey: .eventStatus)
        eventHomeTeam = try container.decodeIfPresent(String.self, forKey: .eventHomeTeam)
                     ?? (try container.decodeIfPresent(String.self, forKey: .eventFirstPlayer))
        
        homeTeamLogo = try container.decodeIfPresent(String.self, forKey: .homeTeamLogo)
                    ?? (try container.decodeIfPresent(String.self, forKey: .eventFirstPlayerLogo))
        
        eventAwayTeam = try container.decodeIfPresent(String.self, forKey: .eventAwayTeam)
                     ?? (try container.decodeIfPresent(String.self, forKey: .eventSecondPlayer))
        
        awayTeamLogo = try container.decodeIfPresent(String.self, forKey: .awayTeamLogo)
                    ?? (try container.decodeIfPresent(String.self, forKey: .eventSecondPlayerLogo))
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .eventKey) {
            eventKey = String(intKey)
        } else {
            eventKey = try container.decodeIfPresent(String.self, forKey: .eventKey)
        }
    }
}
