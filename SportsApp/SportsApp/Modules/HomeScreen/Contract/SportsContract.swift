import Foundation

// What the Presenter can tell the View to do
protocol SportsViewProtocol: AnyObject {
    func displaySports()
    func navigateToLeagues(for sportName: String, endpoint: String)
}

// What the View can ask the Presenter to do
protocol SportsPresenterProtocol {
    var view: SportsViewProtocol? { get set }
    var sportsCount: Int { get }
    func configureCell(at index: Int) -> SportModel
    func didSelectSport(at index: Int)
}
