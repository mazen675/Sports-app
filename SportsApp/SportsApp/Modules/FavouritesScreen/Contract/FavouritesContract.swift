import Foundation

protocol FavouritesViewProtocol: AnyObject {
    func reloadData()
    func showLoading() // 🚨 Added
    func hideLoading() // 🚨 Added
    func navigateToLeagueDetails(league: LeagueModel, sportEndpoint: String) // 🚨 Added for safe navigation
}

protocol FavouritesPresenterProtocol {
    var favouritesCount: Int { get }
    func getFavourite(at index: Int) -> LeagueModel
    func loadFavourites()
    func removeFavourite(at index: Int)
    func didSelectFavourite(at index: Int) // 🚨 Added
}
