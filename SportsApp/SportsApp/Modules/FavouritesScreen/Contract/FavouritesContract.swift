import Foundation

protocol FavouritesViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func navigateToLeagueDetails(league: LeagueModel, sportEndpoint: String)
    func deleteRow(at indexPath: IndexPath)
    func deleteSection(at index: Int)
}

protocol FavouritesPresenterProtocol {
    var numberOfSections: Int { get }
    func titleForSection(_ section: Int) -> String
    func numberOfItems(in section: Int) -> Int
    
    func getFavourite(at indexPath: IndexPath) ->(LeagueModel, String)
    func loadFavourites()
    func removeFavourite(at indexPath: IndexPath)
    func didSelectFavourite(at indexPath: IndexPath)
}
