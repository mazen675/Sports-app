import Foundation

class TennisPlayerPresenter: TennisPlayerPresenterProtocol {
    weak var view: TennisPlayerViewProtocol?
    
    let playerId: String
    
    private var player: TennisPlayerModel?
    
    init(view: TennisPlayerViewProtocol, playerId: String) {
        self.view = view
        self.playerId = playerId
    }
    
    func fetchPlayerDetails() {
        view?.showLoading()
        
        let url = "\(Constants.baseURL)/tennis/?met=Players&playerId=\(playerId)&APIkey=\(Constants.apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<TennisPlayerModel>, Error>) in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    if let fetchedPlayer = response.result?.first {
                        self.player = fetchedPlayer
                        self.view?.reloadData()
                    } else {
                        self.view?.showError(message: "player_not_found".localized)
                    }
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func viewWillAppear() {
        if !hasConnectivity() {
            view?.showNetworkAlert()
        }
    }
    
    
    var numberOfSections: Int {
        return player == nil ? 0 : 3
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard let player = player else { return 0 }
        switch section {
        case 0: return 1
        case 1: return max(1, player.safeStats.count)
        case 2: return max(1, player.safeTournaments.count)
        default: return 0
        }
    }
    
    func hasStats() -> Bool { return !(player?.safeStats.isEmpty ?? true) }
    func hasTournaments() -> Bool { return !(player?.safeTournaments.isEmpty ?? true) }
    
    func getPlayerInfo() -> TennisPlayerModel? { return player }
    func getStat(at index: Int) -> TennisStat { return player!.stats![index] }
    func getTournament(at index: Int) -> TennisTournament { return player!.tournaments![index] }
}
