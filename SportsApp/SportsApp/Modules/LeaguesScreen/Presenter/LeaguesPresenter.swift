import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    
    // 🚨 We use two arrays to handle the Search Logic properly
    private var allLeagues: [LeagueModel] = []
    private var filteredLeagues: [LeagueModel] = []
    
    let sportEndpoint: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: LeaguesViewProtocol, sportEndpoint: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
    }
    
    var leaguesCount: Int { return filteredLeagues.count }
    
    func getLeague(at index: Int) -> LeagueModel {
        return filteredLeagues[index]
    }
    
    func fetchLeagues() {
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Leagues&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<LeagueModel>, Error>) in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                // 🚨 Sorting the items alphabetically by name
                let fetchedLeagues = response.result ?? []
                self.allLeagues = fetchedLeagues.sorted { $0.safeLeagueName.lowercased() < $1.safeLeagueName.lowercased() }
                self.filteredLeagues = self.allLeagues
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    // 🚨 Search Logic implementation
    func filterLeagues(with searchText: String) {
        if searchText.isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { $0.safeLeagueName.lowercased().contains(searchText.lowercased()) }
        }
        view?.reloadData()
    }
    // 🚨 Add these at the bottom of LeaguesPresenter
        func isFavorite(leagueId: String) -> Bool {
            return CoreDataManager.shared.isFavorite(key: leagueId)
        }
        
        func toggleFavorite(league: LeagueModel) {
            CoreDataManager.shared.toggleFavorite(league: league, sport: sportEndpoint)
            view?.reloadData() // Refresh the UI immediately so the heart changes color
        }
}
