//
//  LeagueDetailsViewProtocol.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
}


protocol LeagueDetailsPresenterProtocol {
    var upcomingEventsCount: Int { get }
    var latestEventsCount: Int { get }
    var teamsCount: Int { get }
    
    func getUpcomingEvent(at index: Int) -> EventModel
    func getLatestEvent(at index: Int) -> EventModel
    func getTeam(at index: Int) -> TeamModel
    
    func fetchLeagueDetails()
}
