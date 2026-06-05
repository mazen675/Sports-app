import Foundation
import Reachability
class LeaguesPresenter: LeaguesPresenterProtocol {
    
    weak var view: LeaguesViewProtocol?
    let sportEndpoint: String
  
    private var allLeagues: [LeagueModel] = []
    private var filteredLeagues: [LeagueModel] = []
    var leaguesCount: Int { return filteredLeagues.count }
    
    private let networkService: NetworkFetching
    private let coreDataManager: CoreDataManaging
    
    init(view: LeaguesViewProtocol, sportEndpoint: String, networkService: NetworkFetching = NetworkService.shared, coreDataManager: CoreDataManaging = CoreDataManager.shared) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func fetchLeagues() {
        guard hasConnectivity() else { return }
        view?.showLoading()
        
        let url = "\(Constants.baseURL)/\(sportEndpoint)/?met=Leagues&APIkey=\(Constants.apiKey)"
        
        self.networkService.fetchData(from: url) { [weak self] (result: Result<APIResponse<LeagueModel>, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    let fetchedLeagues = response.result ?? []
                    self.allLeagues = fetchedLeagues.sorted { $0.safeLeagueName.lowercased() < $1.safeLeagueName.lowercased() }
                    self.filteredLeagues = self.allLeagues
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func getLeagueData(at index: Int) -> (league: LeagueModel, placeholder: String, isFavorite: Bool) {
        let league = filteredLeagues[index]
        let placeholder = getPlaceholderImage(for: sportEndpoint)
        let isFav = isFavorite(leagueId: league.leagueKey ?? "")
        
        return (league, placeholder, isFav)
    }
    
    func filterLeagues(with searchText: String) {
        if searchText.isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { $0.safeLeagueName.lowercased().contains(searchText.lowercased()) }
        }
        view?.reloadData()
    }
    
    func didSelectLeague(at index: Int) {
        let selectedLeague = filteredLeagues[index]
        view?.navigateToLeagueDetails(league: selectedLeague, endpoint: sportEndpoint, title: selectedLeague.safeLeagueName)
    }

    func isFavorite(leagueId: String) -> Bool {
        return self.coreDataManager.isFavorite(key: leagueId)
    }
    
    func toggleFavorite(league: LeagueModel) {
        self.coreDataManager.toggleFavorite(league: league, sport: sportEndpoint)
        view?.reloadData()
    }
    
    func viewWillAppear() {
        if !hasConnectivity() {
            view?.showNetworkAlert()
        }
        view?.reloadData()
    }
}
