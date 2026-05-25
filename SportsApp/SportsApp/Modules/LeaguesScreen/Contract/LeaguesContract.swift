import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}

protocol LeaguesPresenterProtocol {
    var leaguesCount: Int { get }
    func getLeague(at index: Int) -> LeagueModel
    func fetchLeagues()
}
