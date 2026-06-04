import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
    func showComingSoonAlert()
    func navigateToTennisPlayer(teamId: String)
    func navigateToTeamDetails(teamId: String, sportEndpoint: String, leagueName: String, leagueExtraInfo: String)
    func showNetworkAlert()
}

protocol LeagueDetailsPresenterProtocol {
    var upcomingEventsCount: Int { get }
    var latestEventsCount: Int { get }
    var teamsCount: Int { get }
    var sportEndpoint: String {get}
    var isNetworkAvailable:Bool {get}
    
    func fetchLeagueDetails()
    func item(at indexPath: IndexPath) -> CollectionViewItem
    func didSelectTeam(at index: Int, section: Int)
    func viewWillAppear()
}
