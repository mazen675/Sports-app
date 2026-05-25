import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}

protocol LeaguesPresenterProtocol {
    var leaguesCount: Int { get }
    
    // 🚨 THE FIX: Add this line so the ViewController can read it!
    var sportEndpoint: String { get }
    
    func getLeague(at index: Int) -> LeagueModel
    func fetchLeagues()
}
