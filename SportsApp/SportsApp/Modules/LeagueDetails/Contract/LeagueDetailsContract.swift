import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
}

protocol LeagueDetailsPresenterProtocol {
    var upcomingEventsCount: Int { get }
    var latestEventsCount: Int { get }
    var teamsCount: Int { get }
    
    // Allows the view to know if it's Tennis or Football
    var sportEndpoint: String { get }
    
    func getUpcomingEvent(at index: Int) -> EventModel
    func getLatestEvent(at index: Int) -> EventModel
    
    // 🚨 THIS IS THE FIX FOR YOUR SCREENSHOT:
    func getTeam(at index: Int) -> TeamModel
    
    func fetchLeagueDetails()
}
