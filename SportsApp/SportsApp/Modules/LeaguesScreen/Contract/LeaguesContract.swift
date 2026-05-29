import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}

protocol LeaguesPresenterProtocol {
    var leaguesCount: Int { get }
    var sportEndpoint: String { get }
    
    func getLeague(at index: Int) -> LeagueModel
    func fetchLeagues()
    func filterLeagues(with searchText: String)
    
    func isFavorite(leagueId: String) -> Bool
    func toggleFavorite(league: LeagueModel)
}
