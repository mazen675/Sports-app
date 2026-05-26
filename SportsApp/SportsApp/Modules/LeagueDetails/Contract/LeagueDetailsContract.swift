import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
    func navigateToTennisPlayer(teamId:String)
    func navigateToTeamDetails(teamId:String, sportEndpoint: String,leagueName:String,leagueExtraInfo:String)
}

protocol LeagueDetailsPresenterProtocol {
    func getUpcomingEvent(at index: Int) -> EventModel
    func getLatestEvent(at index: Int) -> EventModel
    func getTeam(at index: Int) -> TeamModel
    func fetchLeagueDetails()
    func didSelectTeam(at index: Int, section: Int)
    
}
