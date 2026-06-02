import Foundation

protocol SportsViewProtocol: AnyObject {
    func displaySports()
    func navigateToLeagues(for sportName: String, endpoint: String)
}

protocol SportsPresenterProtocol {
    var view: SportsViewProtocol? { get set }
    var sportsCount: Int { get }
    func configureCell(at index: Int) -> SportModel
    func didSelectSport(at index: Int)
}
