import Foundation

enum TennisPlayerItem {
    case header(TennisPlayerModel)
    case stat(TennisStat)
    case tournament(TennisTournament)
    case emptyState(title: String, subtitle: String)
}

class TennisPlayerPresenter: TennisPlayerPresenterProtocol {
    weak var view: TennisPlayerViewProtocol?
    
    let playerId: String
    
    private var player: TennisPlayerModel?
   
    
    var numberOfSections: Int {return player == nil ? 0 : 3}
    private let networkService: NetworkFetching
    
    init(view: TennisPlayerViewProtocol, playerId: String, networkService: NetworkFetching = NetworkService.shared) {
        self.view = view
        self.playerId = playerId
        self.networkService = networkService
    }
    
    func fetchPlayerDetails() {
        view?.showLoading()
        
        let url = "\(Constants.baseURL)/tennis/?met=Players&playerId=\(playerId)&APIkey=\(Constants.apiKey)"
        
        self.networkService.fetchData(from: url) { [weak self] (result: Result<APIResponse<TennisPlayerModel>, Error>) in
            
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
    
    func numberOfItems(in section: Int) -> Int {
        guard let player = player else { return 0 }
        switch section {
        case 0: return 1
        case 1: return max(1, player.safeStats.count)
        case 2: return max(1, player.safeTournaments.count)
        default: return 0
        }
    }
    
    func item(at indexPath: IndexPath) -> TennisPlayerItem {
           
            switch indexPath.section {
            case 0:
                return .header(player!)
                
            case 1:
                if player!.safeStats.isEmpty {
                    return .emptyState(title: "no_statistics_title".localized,
                                       subtitle: "no_statistics_subtitle".localized)
                }
                return .stat(player!.safeStats[indexPath.row])
                
            case 2:
                if player!.safeTournaments.isEmpty {
                    return .emptyState(title: "no_tournaments_title".localized,
                                       subtitle: "no_tournaments_subtitle".localized)
                }
                return .tournament(player!.safeTournaments[indexPath.row])
                
            default:
                fatalError("Unexpected section")
            }
        }
    
    func hasStats() -> Bool { return !(player?.safeStats.isEmpty ?? true) }
    func hasTournaments() -> Bool { return !(player?.safeTournaments.isEmpty ?? true) }
    
}
