import Foundation

enum CollectionViewItem {
    case emptyState(title: String, subtitle: String)
    case team(TeamModel)
    case upcomingEvent(EventModel)
    case latestEvent(EventModel)
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    weak var view: LeagueDetailsViewProtocol?
    
    let sportEndpoint: String
    let league: LeagueModel
    var isNetworkAvailable:Bool = true
    
    private let coreDataManager: CoreDataManaging
    private let networkService: NetworkFetching
    
    private var upcomingEvents: [EventModel] = []
    private var latestEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    
    var upcomingEventsCount: Int { return upcomingEvents.count }
    var latestEventsCount: Int { return latestEvents.count }
    var teamsCount: Int { return teams.count }
    
    init(view: LeagueDetailsViewProtocol, sportEndpoint: String, league: LeagueModel, networkService: NetworkFetching = NetworkService.shared, coreDataManager: CoreDataManaging = CoreDataManager.shared)  {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.league = league
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
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
        self.networkService.fetchData(from: fixturesURL) { [weak self] (result: Result<APIResponse<EventModel>, Error>) in
            print(fixturesURL)
            switch result {
            case .success(let response):
                let allEvents = response.result ?? []
                self?.latestEvents = allEvents.filter { $0.safeEventStatus == "Finished" }
                self?.upcomingEvents = allEvents.filter { $0.safeEventStatus == "" || $0.safeEventStatus == "Not Started" }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            group.leave()
        }
        
        group.enter()
        self.networkService.fetchData(from: teamsURL) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
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
    
    func item(at indexPath: IndexPath) -> CollectionViewItem {
        switch indexPath.section {
        case 0:
            if teamsCount == 0 {
                if sportEndpoint == "tennis" {
                    return .emptyState(title: "no_players_title".localized,
                                       subtitle: "no_players_subtitle".localized)
                }else{
                    return .emptyState(title: "no_teams_title".localized,
                                       subtitle: "no_teams_subtitle".localized)
                }
               
            }
            return .team(teams[indexPath.row])
            
        case 1:
            if upcomingEventsCount == 0 {
                return .emptyState(title: "no_upcoming_events_title".localized,
                                   subtitle: "no_upcoming_events_subtitle".localized)
            }
            return .upcomingEvent(upcomingEvents[indexPath.row])
            
        case 2:
            if latestEventsCount == 0 {
                return .emptyState(title: "no_latest_events_title".localized,
                                   subtitle: "no_latest_events_subtitle".localized)
            }
            return .latestEvent(latestEvents[indexPath.row])
            
        default:
            fatalError("Unexpected section")
        }
    }
    
    func didSelectTeam(at index: Int, section: Int) {
        guard section == 0 else { return }
        guard index < teams.count else { return }
        let selectedTeam = teams[index]
        guard let teamId = selectedTeam.teamKey else { return }

        if sportEndpoint == "basketball" || sportEndpoint == "cricket" {
            view?.showComingSoonAlert()
        } else if sportEndpoint == "tennis" {
            view?.navigateToTennisPlayer(teamId: teamId)
        } else {
            view?.navigateToTeamDetails(teamId: teamId, sportEndpoint: sportEndpoint, leagueName: league.safeLeagueName, leagueExtraInfo: league.safeCountryName)
        }
    }
    
    func isFavoriteLeague() -> Bool {
            guard let key = league.leagueKey else { return false }
            return self.coreDataManager.isFavorite(key: key)
     }
    
    func toggleFavorite() {
            self.coreDataManager.toggleFavorite(league: self.league, sport: self.sportEndpoint)
            let isNowFavorite = isFavoriteLeague()
            view?.updateFavoriteButtonState(isFavorite: isNowFavorite)
    }
    
    func viewWillAppear() {
        if !hasConnectivity() {
            view?.showNetworkAlert()
        }
        let isNowFavorite = isFavoriteLeague()
        view?.updateFavoriteButtonState(isFavorite: isNowFavorite)
        view?.reloadData()
     }
}
