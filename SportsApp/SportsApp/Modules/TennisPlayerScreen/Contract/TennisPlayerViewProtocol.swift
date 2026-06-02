//
//  TennisPlayerViewProtocol.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 25/05/2026.
//
import Foundation

protocol TennisPlayerViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
    func showNetworkAlert()
}

protocol TennisPlayerPresenterProtocol {
    func fetchPlayerDetails()
    func viewWillAppear()
    
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func hasStats() -> Bool
    func hasTournaments() -> Bool
    
    func getPlayerInfo() -> TennisPlayerModel?
    func getStat(at index: Int) -> TennisStat
    func getTournament(at index: Int) -> TennisTournament
}
