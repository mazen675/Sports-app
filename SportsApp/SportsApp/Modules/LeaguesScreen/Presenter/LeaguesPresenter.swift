import Foundation
import Reachability
class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    
    private var allLeagues: [LeagueModel] = []
    private var filteredLeagues: [LeagueModel] = []
    
    let sportEndpoint: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: LeaguesViewProtocol, sportEndpoint: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
    }
    @objc private func networkDropped(notification: Notification) {
        let connection = NetworkManager.shared.reachability?.connection
        
        DispatchQueue.main.async {
            if connection == .unavailable {
                self.view?.showNetworkAlert()
            } else {
               
            }
        }
    }
    var leaguesCount: Int { return filteredLeagues.count }
    
    func getLeague(at index: Int) -> LeagueModel {
        return filteredLeagues[index]
    }
    
    func fetchLeagues() {
        guard NetworkManager.shared.hasConnectivity() else { return }
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Leagues&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<LeagueModel>, Error>) in
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

    func filterLeagues(with searchText: String) {
        if searchText.isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { $0.safeLeagueName.lowercased().contains(searchText.lowercased()) }
        }
        view?.reloadData()
    }

    func isFavorite(leagueId: String) -> Bool {
        return CoreDataManager.shared.isFavorite(key: leagueId)
    }
    
    func toggleFavorite(league: LeagueModel) {
        CoreDataManager.shared.toggleFavorite(league: league, sport: sportEndpoint)
        view?.reloadData()
    }
    
    func viewWillAppear() {
            if !NetworkManager.shared.hasConnectivity() {
                view?.showNetworkAlert()
            }
    }
}
