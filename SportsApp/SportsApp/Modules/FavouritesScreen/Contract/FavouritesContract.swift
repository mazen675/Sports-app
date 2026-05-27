import Foundation

protocol FavouritesViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func navigateToLeagueDetails(league: LeagueModel, sportEndpoint: String)
}

protocol FavouritesPresenterProtocol {
    // 🚨 The new blueprint rules for Sections!
    var numberOfSections: Int { get }
    func titleForSection(_ section: Int) -> String
    func numberOfItems(in section: Int) -> Int
    
    // 🚨 Updated to use 'IndexPath' instead of 'Int'
    func getFavourite(at indexPath: IndexPath) -> LeagueModel
    func loadFavourites()
    func removeFavourite(at indexPath: IndexPath)
    func didSelectFavourite(at indexPath: IndexPath)
}
