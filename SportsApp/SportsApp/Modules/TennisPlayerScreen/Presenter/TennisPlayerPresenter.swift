import Foundation

class TennisPlayerPresenter: TennisPlayerPresenterProtocol {
    weak var view: TennisPlayerViewProtocol?
    
    let playerId: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: TennisPlayerViewProtocol, playerId: String) {
        self.view = view
        self.playerId = playerId
    }
    
    func fetchPlayerDetails() {
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/tennis/?met=Players&playerId=\(playerId)&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<TennisPlayerModel>, Error>) in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    if let player = response.result?.first {
                        self.view?.displayPlayerDetails(player: player)
                    } else {
                        let errorMessage = NSLocalizedString("player_not_found", comment: "Player data not found")
                        self.view?.showError(message: errorMessage)
                    }
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    func viewWillAppear() {
            if !NetworkManager.shared.hasConnectivity() {
                view?.showNetworkAlert()
            }
    }
}
