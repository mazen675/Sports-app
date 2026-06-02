import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    weak var view: TeamDetailsViewProtocol?
    let sportEndpoint: String
    let teamId: String
    let leagueExtraInfo: String
    let leagueName : String
    
    private var groupedSections: [PlayerSection] = []
        
    var numberOfSections: Int { return groupedSections.count }
    
    func numberOfRows(in section: Int) -> Int {
        return groupedSections[section].players.count
    }
    
    func getPlayer(at indexPath: IndexPath) -> Player {
        return groupedSections[indexPath.section].players[indexPath.row]
    }
    
    func getSectionTitle(for section: Int) -> String {
        return groupedSections[section].type
    }
    
    func processPlayers(_ players: [Player]) {
        let groupedDictionary = Dictionary(grouping: players, by: { $0.safePlayerType })
        
        self.groupedSections = groupedDictionary.map { (key, value) in
            PlayerSection(type: key, players: value)
        }
        
        self.groupedSections.sort { section1, section2 in
            return getSortRank(for: section1.type) < getSortRank(for: section2.type)
        }
    }
    
    private func getSortRank(for type: String) -> Int {
            let lowercasedType = type.lowercased()
            if lowercasedType.contains("goalkeeper") { return 0 }
            if lowercasedType.contains("defender") { return 1 }
            if lowercasedType.contains("midfielder") { return 2 }
            if lowercasedType.contains("forward") || lowercasedType.contains("striker") { return 3 }
            return 4
        }

    init(view: TeamDetailsViewProtocol, sportEndpoint: String, teamId: String , leagueExtraInfo: String , leagueName: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.teamId = teamId
        self.leagueName = leagueName
        self.leagueExtraInfo = leagueExtraInfo
    }
    
    func fetchTeamDetails() {
        guard hasConnectivity() else { return }
        view?.showLoading()
        
        let url = "\(Constants.baseURL)/\(sportEndpoint)/?met=Teams&teamId=\(teamId)&APIkey=\(Constants.apiKey)"
        let placeHolder = getPlaceholderImage(for: sportEndpoint)
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    if let team = response.result?.first {
                        self.processPlayers(team.safePlayers)
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
        if !hasConnectivity() {
            view?.showNetworkAlert()
        }
    }
}


struct PlayerSection {
    let type: String
    let players: [Player]
}
