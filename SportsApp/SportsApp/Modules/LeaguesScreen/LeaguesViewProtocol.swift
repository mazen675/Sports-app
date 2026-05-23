//
//  LeaguesViewProtocol.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}

protocol LeaguesPresenterProtocol {
    var leaguesCount: Int { get }
    func getLeague(at index: Int) -> LeagueModel
    func fetchLeagues()
}