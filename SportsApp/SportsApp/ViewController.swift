import UIKit

class ViewController: UIViewController {

    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Test League Details (Events)
        testFetchEvents(sportEndpoint: "football", from: "2024-10-01", to: "2024-10-10")
        
        // 2. Test Team Details (Squads & Coaches for Football)
        testFetchTeamDetails(sportEndpoint: "football", teamId: "96")
        
    }
    
    // MARK: - Simulate League Details Presenter
    func testFetchEvents(sportEndpoint: String, from dateFrom: String, to dateTo: String) {
        print("\n⏳ Fetching Events for \(sportEndpoint.uppercased())...")
        // Notice the updated apiv2 URL structure
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
    
    // MARK: - Simulate Team Details Presenter
    func testFetchTeamDetails(sportEndpoint: String, teamId: String) {
        print("\n⏳ Fetching Team Details for \(sportEndpoint.uppercased()) (ID: \(teamId))...")
        // Notice the updated apiv2 URL structure
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
                    
                    // Test Coach availability
                    if let coach = team.safeCoaches.first {
                        print("👔 Coach: \(coach.safeCoachName)")
                    } else {
                        print("👔 Coach: N/A (Expected for Tennis/Some Cricket)")
                    }
                    
                    // Test Squad availability
                    let squad = team.safePlayers
                    if squad.isEmpty {
                        print("👥 Squad: Empty (This is Tennis! Hide the Squad UI table.)")
                    } else {
                        print("👥 Squad Size: \(squad.count) players")
                        if let topPlayer = squad.first {
                            print("⭐ Top Player: \(topPlayer.safePlayerName) (#\(topPlayer.safePlayerNumber) - \(topPlayer.safePlayerType))")
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Team Fetch Failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
