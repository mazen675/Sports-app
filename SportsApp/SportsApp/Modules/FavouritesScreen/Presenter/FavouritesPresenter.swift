import Foundation

class FavouritesPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    
    // 🚨 We now store an array of Sections (each section has a sport name and an array of leagues)
    private var sections: [(sport: String, leagues: [LeagueModel])] = []
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }
    
    // MARK: - Section Data Methods
    var numberOfSections: Int { return sections.count }
    
    func titleForSection(_ section: Int) -> String {
        return sections[section].sport.capitalized // E.g., "football" becomes "Football"
    }
    
    func numberOfItems(in section: Int) -> Int {
        return sections[section].leagues.count
    }
    
    func getFavourite(at indexPath: IndexPath) -> LeagueModel {
        return sections[indexPath.section].leagues[indexPath.row]
    }
    
    // MARK: - Fetching Data
    func loadFavourites() {
        view?.showLoading()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let savedEntities = CoreDataManager.shared.fetchAllFavorites()
            
            // 1. Group all leagues by their sport
            var groupedBySport: [String: [LeagueModel]] = [:]
            
            for entity in savedEntities {
                let league = LeagueModel(
                    leagueKey: entity.value(forKey: "key") as? String,
                    leagueName: entity.value(forKey: "name") as? String,
                    leagueLogo: entity.value(forKey: "logo") as? String,
                    countryName: entity.value(forKey: "info") as? String,
                    leagueYear: nil
                )
                let sport = entity.value(forKey: "sport") as? String ?? "football"
                groupedBySport[sport, default: []].append(league)
            }
            
            // 2. Order the sections perfectly
            let order = ["football", "basketball", "tennis", "cricket"]
            var newSections: [(sport: String, leagues: [LeagueModel])] = []
            
            for sport in order {
                if let leagues = groupedBySport[sport], !leagues.isEmpty {
                    newSections.append((sport: sport, leagues: leagues))
                }
            }
            
            // 3. Push back to Main UI
            DispatchQueue.main.async {
                self?.sections = newSections
                self?.view?.hideLoading()
                self?.view?.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    func removeFavourite(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        
        // 1. Delete from Core Data
        if let key = league.leagueKey {
            CoreDataManager.shared.deleteLeague(key: key)
        }
        
        // 2. Delete from our RAM array
        sections[indexPath.section].leagues.remove(at: indexPath.row)
        
        // 3. If the section is empty (e.g., deleted the last Tennis league), remove the section entirely!
        if sections[indexPath.section].leagues.isEmpty {
            sections.remove(at: indexPath.section)
        }
    }
    
    func didSelectFavourite(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        let sport = sections[indexPath.section].sport
        view?.navigateToLeagueDetails(league: league, sportEndpoint: sport)
    }
}
