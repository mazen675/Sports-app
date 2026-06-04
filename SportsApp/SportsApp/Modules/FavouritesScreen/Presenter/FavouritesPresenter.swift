import Foundation

class FavouritesPresenter: FavouritesPresenterProtocol {
    weak var view: FavouritesViewProtocol?
    
    private var sections: [(sport: String, leagues: [LeagueModel])] = []
    var numberOfSections: Int { return sections.count }
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }
    
    func titleForSection(_ section: Int) -> String {
        return sections[section].sport.capitalized.localized
    }
    
    func numberOfItems(in section: Int) -> Int {
        return sections[section].leagues.count
    }
    
    func getFavourite(at indexPath: IndexPath) -> (LeagueModel, String) {
        return (sections[indexPath.section].leagues[indexPath.row],getPlaceholderImage(for: sections[indexPath.section].sport))
    }
    
    func loadFavourites() {
        view?.showLoading()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let savedEntities = CoreDataManager.shared.fetchAllFavorites()
            
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
            
            let order = ["football", "basketball", "tennis", "cricket"]
            var newSections: [(sport: String, leagues: [LeagueModel])] = []
            
            for sport in order {
                if let leagues = groupedBySport[sport], !leagues.isEmpty {
                    newSections.append((sport: sport, leagues: leagues))
                }
            }
            
            DispatchQueue.main.async {
                self?.sections = newSections
                self?.view?.hideLoading()
                self?.view?.reloadData()
            }
        }
    }
    
    func removeFavourite(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        if let key = league.leagueKey { CoreDataManager.shared.deleteLeague(key: key) }
        
        let sectionsBefore = sections.count
        sections[indexPath.section].leagues.remove(at: indexPath.row)
        
        if sections[indexPath.section].leagues.isEmpty {
            sections.remove(at: indexPath.section)
        }
        
        if sections.count < sectionsBefore {
            view?.deleteSection(at: indexPath.section)
        } else {
            view?.deleteRow(at: indexPath)
        }
    }
    
    func didSelectFavourite(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        let sport = sections[indexPath.section].sport
        view?.navigateToLeagueDetails(league: league, sportEndpoint: sport)
    }
}
