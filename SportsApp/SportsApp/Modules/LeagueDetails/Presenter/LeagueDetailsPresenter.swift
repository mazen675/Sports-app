//
//  LeagueDetailsViewProtocol.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
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
            let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
            let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
            
            let fromDate = dateFormatter.string(from: lastYear)
            let toDate = dateFormatter.string(from: nextYear)
            
            let fixturesURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Fixtures&leagueId=\(leagueId)&from=\(fromDate)&to=\(toDate)&APIkey=\(apiKey)"
            
            let teamsURL = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
            
            NetworkService.shared.fetchData(from: fixturesURL) { [weak self] (result: Result<APIResponse<EventModel>, Error>) in
                self?.view?.hideLoading()
                
                switch result {
                case .success(let response):
                    let allEvents = response.result ?? []
                    self?.latestEvents = allEvents.filter { $0.eventFinalResult != nil && $0.eventFinalResult != "-" }
                    self?.upcomingEvents = allEvents.filter { $0.eventFinalResult == nil || $0.eventFinalResult == "-" }
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
}
