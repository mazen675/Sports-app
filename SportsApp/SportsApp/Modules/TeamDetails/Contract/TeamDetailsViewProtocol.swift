//
//  TeamDetailsViewProtocol.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 25/05/2026.
//


import Foundation

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func displayTeamDetails(team: TeamModel, leagueName: String , leagueExtraInfo: String , placeHolder:String)
    func showNetworkAlert()
}

protocol TeamDetailsPresenterProtocol {
    var numberOfSections: Int { get }
    
    func numberOfRows(in section: Int) -> Int
    func getPlayer(at indexPath: IndexPath) -> Player
    func getSectionTitle(for section: Int) -> String
    
    func fetchTeamDetails()
    func viewWillAppear()
}

