import Foundation

protocol FavouritesViewProtocol: AnyObject {
    func reloadData()
}

protocol FavouritesPresenterProtocol {
    var favouritesCount: Int { get }
    func getFavourite(at index: Int) -> LeagueModel
    func loadFavourites()
    func removeFavourite(at index: Int)
}
