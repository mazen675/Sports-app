import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
    func showNetworkAlert()
    func navigateToLeagueDetails(league: LeagueModel, endpoint: String, title: String) 
}

protocol LeaguesPresenterProtocol {
    var leaguesCount: Int { get }
    var sportEndpoint: String { get }
    
    func getLeagueData(at index: Int) -> (league: LeagueModel, placeholder: String, isFavorite: Bool)
    func fetchLeagues()
    func filterLeagues(with searchText: String)
    
    func isFavorite(leagueId: Int) -> Bool
    func toggleFavorite(league: LeagueModel)
    func viewWillAppear()
    
    func didSelectLeague(at index: Int)
}
