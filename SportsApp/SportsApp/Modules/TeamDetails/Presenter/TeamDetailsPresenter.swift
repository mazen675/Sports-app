import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    weak var view: TeamDetailsViewProtocol?
    let sportEndpoint: String
    let teamId: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    let leagueExtraInfo: String
    let leagueName : String
    
    init(view: TeamDetailsViewProtocol, sportEndpoint: String, teamId: String , leagueExtraInfo: String , leagueName: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.teamId = teamId
        self.leagueName = leagueName
        self.leagueExtraInfo = leagueExtraInfo
    }
    
    func fetchTeamDetails() {
        guard NetworkManager.shared.hasConnectivity() else { return }
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"
        let placeHolder = getPlaceholderImage(for: sportEndpoint)
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    if let team = response.result?.first {
                        self.view?.displayTeamDetails(team: team, leagueName: self.leagueName, leagueExtraInfo: self.leagueExtraInfo,placeHolder: placeHolder)
                    } else {
                        let errorMessage = NSLocalizedString("team_not_found", comment: "Team data not found")
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
