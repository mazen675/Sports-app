//
//  LeaguesPresenter.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    private var leagues: [LeagueModel] = []
    
    // We pass the sport endpoint (e.g., "football") from the previous screen
    let sportEndpoint: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    
    init(view: LeaguesViewProtocol, sportEndpoint: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
    }
    
    var leaguesCount: Int { return leagues.count }
    
    func getLeague(at index: Int) -> LeagueModel {
        return leagues[index]
    }
    
    func fetchLeagues() {
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Leagues&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<LeagueModel>, Error>) in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                self.leagues = response.result ?? []
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
}