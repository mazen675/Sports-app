import Foundation

struct EventModel: Decodable {
    var eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
  
    let eventAwayTeam: String?
    
    let eventFinalResult: String?
    let eventStatus: String?
    
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    
    let eventFirstPlayer :String?
    let eventFirstPlayerLogo :String?
    let eventSecondPlayer :String?
    let eventSecondPlayerLogo :String?
    
    
    var safeEventStatus: String { return eventStatus ?? "" }
    var safeHomeTeam: String { return eventHomeTeam ?? eventFirstPlayer ?? "TBD" }
    var safeAwayTeam: String { return eventAwayTeam ?? eventSecondPlayer ?? "TBD" }
    
    var safeScore: String { return eventFinalResult ?? "vs" }
    
    var safeDate: String { return eventDate ?? "Date TBD" }
    var safeTime: String { return eventTime ?? "Time TBD" }
    
    

    var safeHomeLogo: String? { return homeTeamLogo ?? eventFirstPlayerLogo }
        
    var safeAwayLogo: String? { return awayTeamLogo ?? eventSecondPlayerLogo }

}
