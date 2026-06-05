//
//  MockTeamDetailsView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp
class MockTeamDetailsView: TeamDetailsViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var displayedTeam: TeamModel?
    var errorMessage: String?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func showError(message: String) { errorMessage = message }
    func showNetworkAlert() {}
    
    func displayTeamDetails(team: TeamModel, leagueName: String, leagueExtraInfo: String, placeHolder: String) {
        displayedTeam = team
    }
}
