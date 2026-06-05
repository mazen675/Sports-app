//
//  MockLeagueDetailsView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp
class MockLeagueDetailsView: LeagueDetailsViewProtocol {
 
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var isComingSoonAlertShown = false
    var navigatedToTeamId: String?
    var navigatedToTennisPlayerId: String?
    var updatedFavoriteState: Bool?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showNetworkAlert() {}
    func showComingSoonAlert() { isComingSoonAlertShown = true }
    func showError(_ message: String) { print(message) }
    func navigateToTeamDetails(teamId: String, sportEndpoint: String, leagueName: String, leagueExtraInfo: String) {
        navigatedToTeamId = teamId
    }
    
    func navigateToTennisPlayer(teamId: String) {
        navigatedToTennisPlayerId = teamId
    }
    
    func updateFavoriteButtonState(isFavorite: Bool) {
        updatedFavoriteState = isFavorite
    }
}
