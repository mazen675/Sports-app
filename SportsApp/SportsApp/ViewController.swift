import UIKit

class ViewController: UIViewController {

    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Test League Details (Events)
        testFetchEvents(sportEndpoint: "football", from: "2024-01-01", to: "2024-12-31")
        
        // 2. Test Team Details (Squads & Coaches for Football)
        testFetchTeamDetails(sportEndpoint: "football", teamId: "96")
        
        // 3. Test Individual Sport Details (Tennis Player using the new Model!)
        testFetchTennisPlayer(playerId: "1905") // 1905 is Novak Djokovic
    }
    
    // MARK: - Simulate League Details Presenter
    func testFetchEvents(sportEndpoint: String, from dateFrom: String, to dateTo: String) {
        print("\n⏳ Fetching Events for \(sportEndpoint.uppercased())...")
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Fixtures&from=\(dateFrom)&to=\(dateTo)&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { (result: Result<APIResponse<EventModel>, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let events = response.result, !events.isEmpty else {
                        print("⚠️ No events found for this date range.")
                        return
                    }
                    print("✅ Successfully fetched \(events.count) \(sportEndpoint) Events!")
                    if let firstEvent = events.first {
                        print("🏟️ Sample Match: \(firstEvent.safeHomeTeam) vs \(firstEvent.safeAwayTeam)")
                        print("📈 Score: \(firstEvent.safeScore) | 🕒 \(firstEvent.safeDate) at \(firstEvent.safeTime)")
                    }
                case .failure(let error):
                    print("❌ Event Fetch Failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Simulate Team Details Presenter (For Football, Basketball, Cricket)
    func testFetchTeamDetails(sportEndpoint: String, teamId: String) {
        print("\n⏳ Fetching Team Details for \(sportEndpoint.uppercased()) (ID: \(teamId))...")
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { (result: Result<APIResponse<TeamModel>, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let teams = response.result, let team = teams.first else {
                        print("⚠️ Team data not found.")
                        return
                    }
                    
                    print("✅ Successfully fetched profile for: \(team.safeTeamName)")
                    
                    if let coach = team.safeCoaches.first {
                        print("👔 Coach: \(coach.safeCoachName)")
                    }
                    
                    let squad = team.safePlayers
                    if !squad.isEmpty {
                        print("👥 Squad Size: \(squad.count) players")
                    }
                    
                case .failure(let error):
                    print("❌ Team Fetch Failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Simulate Tennis Player Presenter
    func testFetchTennisPlayer(playerId: String) {
        print("\n⏳ Fetching Tennis Player Details (ID: \(playerId))...")
        // Notice we are using the Players endpoint specifically for Tennis
        let url = "https://apiv2.allsportsapi.com/tennis/?met=Players&playerId=\(playerId)&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { (result: Result<APIResponse<TennisPlayerModel>, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let players = response.result, let player = players.first else {
                        print("⚠️ Tennis player data not found.")
                        return
                    }
                    
                    print("✅ Successfully fetched profile for: \(player.safeName)")
                    print("🌍 Subtitle Info: \(player.safeSubtitle)")
                    
                    // Test Stats
                    if let firstStat = player.safeStats.first {
                        print("📊 Latest Stat: \(firstStat.safeDisplay)")
                    }
                    
                    // Test Tournaments
                    print("🏆 Tournaments Played: \(player.safeTournaments.count)")
                    if let firstTournament = player.safeTournaments.first {
                        print("🥇 Top Tournament: \(firstTournament.safeName) (\(firstTournament.safeDetails))")
                    }
                    
                case .failure(let error):
                    print("❌ Tennis Player Fetch Failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
