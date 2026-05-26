//
//  TeamDetailsPresenter.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 25/05/2026.
//


import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    weak var view: TeamDetailsViewProtocol?
    
    let sportEndpoint: String
    let teamId: String
    let apiKey = "94020ba3429f1ccbe0468c475db80ec2c5ae6626f3a46960d6fec1bcd5e8513c"
    let leagueExtraInfo:String
    let leagueName : String
    
    init(view: TeamDetailsViewProtocol, sportEndpoint: String, teamId: String , leagueExtraInfo: String , leagueName: String) {
        self.view = view
        self.sportEndpoint = sportEndpoint
        self.teamId = teamId
        self.leagueName = leagueName
        self.leagueExtraInfo = leagueExtraInfo
    }
    
    func fetchTeamDetails() {
        view?.showLoading()
        
        let url = "https://apiv2.allsportsapi.com/\(sportEndpoint)/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"
        
        NetworkService.shared.fetchData(from: url) { [weak self] (result: Result<APIResponse<TeamModel>, Error>) in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                if let team = response.result?.first {
                    self.view?.displayTeamDetails(team: team , leagueName: leagueName , leagueExtraInfo: leagueExtraInfo)
                } else {
                    self.view?.showError(message: "Team data not found.")
                }
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
