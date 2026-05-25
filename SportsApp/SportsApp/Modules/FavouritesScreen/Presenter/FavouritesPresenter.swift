import Foundation

class FavouritesPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    private var favoritesList: [LeagueModel] = []
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }
    
    var favouritesCount: Int {
        return favoritesList.count
    }
    
    func getFavourite(at index: Int) -> LeagueModel {
        return favoritesList[index]
    }
    
    func loadFavourites() {
        let savedEntities = CoreDataManager.shared.fetchAllFavorites()
        favoritesList = savedEntities.map { entity in
            LeagueModel(
                leagueKey: entity.value(forKey: "key") as? String,
                leagueName: entity.value(forKey: "name") as? String,
                leagueLogo: entity.value(forKey: "logo") as? String,
                countryName: entity.value(forKey: "info") as? String,
                leagueYear: nil
            )
        }
        
        view?.reloadData()
    }
    
    func removeFavourite(at index: Int) {
        let league = favoritesList[index]
        
        if let key = league.leagueKey {
            CoreDataManager.shared.deleteLeague(key: key)
        }
        
        favoritesList.remove(at: index)
    }
}
