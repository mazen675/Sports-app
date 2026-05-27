import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    weak var view: LeagueDetailsViewProtocol?
    
    private var upcomingEvents: [EventModel] = []
    private var latestEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    
    let sportEndpoint: String
    let league: LeagueModel
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: LeagueDetailsViewProtocol, sportEndpoint: String, league: LeagueModel) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.league = league
    }
    
    var upcomingEventsCount: Int { return upcomingEvents.count }
    var latestEventsCount: Int { return latestEvents.count }
    var teamsCount: Int { return teams.count }
    
    func getUpcomingEvent(at index: Int) -> EventModel { return upcomingEvents[index] }
    func getLatestEvent(at index: Int) -> EventModel { return latestEvents[index] }
    func getTeam(at index: Int) -> TeamModel { return teams[index] }
    
    func fetchLeagueDetails() {
        view?.showLoading()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let fromDate = dateFormatter.string(from: pastDate)
        let toDate = dateFormatter.string(from: futureDate)
        
        guard let leagueId = league.leagueKey else { return }
        
        let fixturesURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        var teamsURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        
        if sportEndpoint == "tennis" {
            teamsURL = "https://apiv2.allsportsapi.com/tennis/?met=Players&leagueId=\(leagueId)&APIkey=\(apiKey)"
        }
        
        NetworkService.shared.fetchData(from: fixturesURL) { [weak self] (result: Result<APIResponse<EventModel>, Error>) in
            self?.view?.hideLoading()
            switch result {
            case .success(let response):
                let allEvents = response.result ?? []
                self?.latestEvents = allEvents.filter { $0.eventFinalResult != nil && $0.eventFinalResult != "-" && $0.eventFinalResult != "" }
                self?.upcomingEvents = allEvents.filter { $0.eventFinalResult == nil || $0.eventFinalResult == "-" || $0.eventFinalResult == "" }
                self?.view?.reloadData()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        
        NetworkService.shared.fetchData(from: teamsURL) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
            self?.view?.hideLoading()
            switch result {
            case .success(let response):
                self?.teams = response.result ?? []
                self?.view?.reloadData()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    // 🚨 Logic to decide whether to show Alert or Navigate
    func didSelectTeam(at index: Int, section: Int) {
        guard section == 0 else { return }
        let selectedTeam = getTeam(at: index)
        guard let teamId = selectedTeam.teamKey else { return }

        if sportEndpoint == "basketball" || sportEndpoint == "cricket" {
            view?.showComingSoonAlert() // Trigger Alert
        } else if sportEndpoint == "tennis" {
            view?.navigateToTennisPlayer(teamId: teamId)
        } else {
            view?.navigateToTeamDetails(teamId: teamId, sportEndpoint: sportEndpoint, leagueName: league.safeLeagueName, leagueExtraInfo: league.safeCountryName)
        }
    }
}
