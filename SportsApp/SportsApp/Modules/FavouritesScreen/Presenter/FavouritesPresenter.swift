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
        // We keep your dummy data logic here. Later, replace this with CoreData!
        let fakeLeague = LeagueModel(leagueKey: "1", 
                                     leagueName: "Test Premier League", 
                                     leagueLogo: "https://apiv2.allsportsapi.com/logo/logo_leagues/152_premier-league.png", 
                                     countryName: "England")
        
        favoritesList = [fakeLeague]
        
        // Tell the view to update
        view?.reloadData()
    }
}
