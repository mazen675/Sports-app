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
    func displayTeamDetails(team: TeamModel)
    func showError(message: String)
}

protocol TeamDetailsPresenterProtocol {
    func fetchTeamDetails()
}