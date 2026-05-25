//
//  LeagueDetailsPresenter.swift
//  SportsApp
//

import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    weak var view: LeagueDetailsViewProtocol?
    
    private var upcomingEvents: [EventModel] = []
    private var latestEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    
    let sportEndpoint: String
    let leagueId: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: LeagueDetailsViewProtocol, sportEndpoint: String, leagueId: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.leagueId = leagueId
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
        
        let fixturesURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
        let teamsURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        
        // 1. Fetch Fixtures
        NetworkService.shared.fetchData(from: fixturesURL) { [weak self] (result: Result<APIResponse<EventModel>, Error>) in
            self?.view?.hideLoading()
            
            switch result {
            case .success(let response):
                let allEvents = response.result ?? []
                // Split events based on whether they have a final score
                self?.latestEvents = allEvents.filter { $0.eventFinalResult != nil && $0.eventFinalResult != "-" }
                self?.upcomingEvents = allEvents.filter { $0.eventFinalResult == nil || $0.eventFinalResult == "-" }
                self?.view?.reloadData()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        
        // 2. Fetch Teams
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
}
