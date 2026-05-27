import Foundation

class FavouritesPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    
    // 🚨 We store both the League and its Sport so it never crashes!
    private var favoritesList: [(league: LeagueModel, sport: String)] = []
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }
    
    var favouritesCount: Int {
        return favoritesList.count
    }
    
    func getFavourite(at index: Int) -> LeagueModel {
        return favoritesList[index].league
    }
    
    func loadFavourites() {
        view?.showLoading() // 🚨 Show Spinner
        
        // 🚨 Fetch from CoreData in Background Thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let savedEntities = CoreDataManager.shared.fetchAllFavorites()
            
            var tempFavorites: [(league: LeagueModel, sport: String)] = []
            
            for entity in savedEntities {
                let league = LeagueModel(
                    leagueKey: entity.value(forKey: "key") as? String,
                    leagueName: entity.value(forKey: "name") as? String,
                    leagueLogo: entity.value(forKey: "logo") as? String,
                    countryName: entity.value(forKey: "info") as? String,
                    leagueYear: nil
                )
                // Default to football if sport is missing to prevent crashes
                let sport = entity.value(forKey: "sport") as? String ?? "football"
                tempFavorites.append((league: league, sport: sport))
            }
            
            // 🚨 Return to Main Thread to update UI
            DispatchQueue.main.async {
                self?.favoritesList = tempFavorites
                self?.view?.hideLoading()
                self?.view?.reloadData()
            }
        }
    }
    
    func removeFavourite(at index: Int) {
        let league = favoritesList[index].league
        
        if let key = league.leagueKey {
            CoreDataManager.shared.deleteLeague(key: key)
        }
        
        favoritesList.remove(at: index)
    }
    
    func didSelectFavourite(at index: Int) {
        let item = favoritesList[index]
        // 🚨 Tell the View to navigate safely using the correct sport
        view?.navigateToLeagueDetails(league: item.league, sportEndpoint: item.sport)
    }
}
