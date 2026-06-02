import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    weak var view: LeagueDetailsViewProtocol?
    
    private var upcomingEvents: [EventModel] = []
    private var latestEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    
    let sportEndpoint: String
    let league: LeagueModel
    var isNetworkAvailable:Bool = true
    
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
        guard hasConnectivity() else {
            isNetworkAvailable = false
            return
        }
        guard let leagueId = league.leagueKey else { return }
        
        view?.showLoading()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        let today = Date()
        let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let fromDate = dateFormatter.string(from: pastDate)
        let toDate = dateFormatter.string(from: futureDate)
        
        let fixturesURL = "\(Constants.baseURL)/\(sportEndpoint)/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(Constants.apiKey)"
        var teamsURL = ""
        
        if sportEndpoint == "tennis" {
            teamsURL = "\(Constants.baseURL)/\(sportEndpoint)/?met=Players&leagueId=\(leagueId)&APIkey=\(Constants.apiKey)"
        } else {
            teamsURL = "\(Constants.baseURL)/\(sportEndpoint)/?met=Teams&leagueId=\(leagueId)&APIkey=\(Constants.apiKey)"
        }
        
        let group = DispatchGroup()
        
        group.enter()
        NetworkService.shared.fetchData(from: fixturesURL) { [weak self] (result: Result<APIResponse<EventModel>, Error>) in
            print(fixturesURL)
            switch result {
            case .success(let response):
                let allEvents = response.result ?? []
                self?.latestEvents = allEvents.filter { $0.eventFinalResult != nil && $0.eventFinalResult != "-" && $0.eventFinalResult != "" }
                self?.upcomingEvents = allEvents.filter { $0.eventFinalResult == nil || $0.eventFinalResult == "-" || $0.eventFinalResult == "" }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        NetworkService.shared.fetchData(from: teamsURL) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
            switch result {
            case .success(let response):
                self?.teams = response.result ?? []
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoading()
            self?.view?.reloadData()
        }
    }
    
    func didSelectTeam(at index: Int, section: Int) {
        guard section == 0 else { return }
        let selectedTeam = getTeam(at: index)
        guard let teamId = selectedTeam.teamKey else { return }

        if sportEndpoint == "basketball" || sportEndpoint == "cricket" {
            view?.showComingSoonAlert()
        } else if sportEndpoint == "tennis" {
            view?.navigateToTennisPlayer(teamId: teamId)
        } else {
            view?.navigateToTeamDetails(teamId: teamId, sportEndpoint: sportEndpoint, leagueName: league.safeLeagueName, leagueExtraInfo: league.safeCountryName)
        }
    }
    
    func viewWillAppear() {
        if !hasConnectivity() {
            view?.showNetworkAlert()
        }
     }
}
